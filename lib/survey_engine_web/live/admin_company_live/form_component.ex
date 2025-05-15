defmodule SurveyEngineWeb.AdminCompanyLive.FormComponent do
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.BusinessModels
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        id="admin_company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div :if={@action == :edit}>
          <.combo_box
            field={@form[:language]}
            type="select"
            label="Language"
            placeholder="Selecciona un lenguage"
            options={[{"Español", "es"}, {"Ingles", "en"}]}
          />
          <.field field={@form[:agency_name]} type="text" label="Nombre de la agencia" />

          <.field field={@form[:legal_name]} type="text" label="Legal name" />
          <.combo_box
            field={@form[:country]}
            type="select"
            placeholder="Selecciona el pais"
            label="Country"
            options={@countries}
          />
          <.combo_box
            field={@form[:town]}
            type="select"
            label="Town"
            placeholder="Selecciona el estado"
            options={@towns}
          />
          <.field field={@form[:city]} type="text" label="City" />
          <.combo_box
            field={@form[:agency_model]}
            placeholder="Selecciona el modelo de agencia"
            type="select"
            options={@agency_models}
            label="Agency model"
          />
          <.combo_box
            field={@form[:agency_type]}
            placeholder="Selecciona el tipo de agencia"
            type="select"
            options={@agency_types}
            label="Agency type"
          />
          <.combo_box
            field={@form[:billing_currency]}
            placeholder="Selecciona una moneda de facturacion"
            type="select"
            label="Billing currency"
            options={@currencies}
          />
        </div>
        <.combo_box
          :if={@action == :assign}
          field={@form[:business_model_id]}
          placeholder="Selecciona una moneda de facturacion"
          type="select"
          label="Modelo de negocio"
          options={@business_models}
        />
        <.input field={@form[:user_id]} type="hidden" value={@user_id} />
        <.button phx-disable-with="Saving...">Guardar</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{action: :validate, company_params: company_params}, socket) do
    {:ok,
     assign(socket,
       towns: get_towns_by_country(company_params["country"])
     )}
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset =
      Companies.change_company(company)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:agency_models, Catalogs.list_agency_models() |> Enum.map(&{&1.name, &1.name}))
      |> assign(
        :business_models,
        BusinessModels.list_business_models()
        |> Enum.map(&{&1.name, &1.id})
      )
      |> assign(:towns, get_towns_by_country(company.country))
      |> assign_form(changeset)
    }
  end

  @impl true
  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset = Companies.change_company(socket.assigns.company, company_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(
           socket.assigns.company,
           company_params
         ) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form registration updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_company(socket, :assign, company_params) do
    case Companies.update_company(
           socket.assigns.company,
           company_params |> Map.put("status", "assigned")
         ) do
      {:ok, company} ->
        NotificationManager.notify_business_model_assigned(
          company,
          url(~p"/"),
          socket.assigns.site_config
        )

        {:noreply,
         socket
         |> put_flash(:info, "Form registration updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp get_towns_by_country(nil), do: []
  defp get_towns_by_country(""), do: []

  defp get_towns_by_country(country) do
    country =
      Countries.filter_by(:alpha2, country)
      |> List.first()

    country
    |> Countries.Subdivisions.all()
    |> Enum.map(&{&1.name, &1.name})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
