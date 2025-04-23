defmodule SurveyEngineWeb.CompanyLive.FormComponent do
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.field field={@form[:date]} type="hidden" value={Timex.today()} />
      <.combo_box
        field={@form[:language]}
        type="select"
        label="Language"
        placeholder="Selecciona un lenguage"
        options={[{"Español", "es"}, {"Ingles", "en"}]}
      />
      <.field field={@form[:agency_name]} type="text" label="Nombre de la agencia" />
      <.field field={@form[:rfc]} type="text" label="Rfc" />
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
        field={@form[:agency_type]}
        placeholder="Selecciona el tipo de agencia"
        type="select"
        options={@agency_types}
        label="Agency type"
      />
      <.combo_box
        field={@form[:agency_model]}
        placeholder="Selecciona el tipo de agencia"
        type="select"
        options={@agency_models}
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
  def update(%{company: _company} = assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:agency_models, Catalogs.list_agency_models() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:towns, [])
    }
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(
           socket.assigns.company,
           company_params
         ) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Form registration updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Companies.create_company(
           company_params
           |> Map.put("user_id", socket.assigns.current_user.id)
         ) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Form registration created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

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
end
