defmodule SurveyEngineWeb.CompanyLive.FormComponent do
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
        <div class="grid grid-cols-12 sm:grid-cols-6 lg:grid-cols-6 gap-6 pb-5">
          <.field field={@form[:language]} type="hidden" value={@locale} />
          <div class="col-span-12 lg:col-span-12 md:col-span-12">
            <.field
              field={@form[:agency_name]}
              type="text"
              label={gettext_with_locale(@locale, gettext("label.agencyname"))}
              required
            />
          </div>
          <div class="col-span-12 lg:col-span-12 md:col-span-12">
            <.field
              field={@form[:legal_name]}
              type="text"
              label={gettext_with_locale(@locale, gettext("label.fullname"))}
              required
            />
          </div>

          <div class="col-span-12 lg:col-span-12 md:col-span-12">
            <.field
              field={@form[:country]}
              type="select"
              prompt={gettext_with_locale(@locale, gettext("placeholder.select.country"))}
              label={gettext_with_locale(@locale, gettext("country"))}
              options={@countries}
              required
            />
          </div>
          <div class="col-span-12 lg:col-span-6 md:col-span-6">
            <.field
              field={@form[:town]}
              type="select"
              label={gettext_with_locale(@locale, gettext("label.state"))}
              prompt={gettext_with_locale(@locale, gettext("placeholder.select.state"))}
              options={@towns}
              required
            />
          </div>
          <div class="col-span-12 lg:col-span-6 md:col-span-6">
            <.field
              field={@form[:city]}
              type="text"
              label={gettext_with_locale(@locale, gettext("label.city"))}
              required
              placeholder={gettext_with_locale(@locale, gettext("placeholder.city"))}
            />
          </div>
          <div class="col-span-12 lg:col-span-12 md:col-span-12" id="phone-input">
            <.label>
              {gettext_with_locale(@locale, gettext("label.phone_number"))}
            </.label>
            <.input
              field={@form[:phone]}
              phx-update="ignore"
              phx-hook="PhoneInput"
              data-country={Phoenix.HTML.Form.input_value(@form, :country)}
              data-start-number={@phone_start_number}
              type="text"
              required
            />
          </div>
          <div class="col-span-12 lg:col-span-6 md:col-span-4">
            <.field
              field={@form[:billing_currency]}
              prompt={gettext_with_locale(@locale, gettext("placeholder.select.billing.currency"))}
              type="select"
              label={gettext_with_locale(@locale, gettext("label.billing.currency"))}
              options={@currencies}
              required
            />
          </div>
          <div class="col-span-9 lg:col-span-8 md:col-span-8">
            <.field
              field={@form[:agency_type]}
              prompt={gettext_with_locale(@locale, gettext("placeholder.select.agency.type"))}
              type="select"
              options={@agency_types}
              label={gettext_with_locale(@locale, gettext("agency.type"))}
              required
            />
          </div>

          <div class="col-span-12 lg:col-span-6 md:col-span-4">
            <.field
              field={@form[:agency_model]}
              prompt={gettext_with_locale(@locale, gettext("placeholder.select.agency.model"))}
              type="select"
              options={@agency_models}
              label={gettext_with_locale(@locale, gettext("agency.model"))}
              required
            />
          </div>

          <div class="col-span-3 lg:col-span-3 md:col-span-3 self-center"></div>
          <div class="col-span-12">
            <label>{gettext("socialnetwork.title")}</label>
            <input type="hidden" name="user[company][link_drop][]" />
            <.inputs_for :let={links_form} field={@form[:links]}>
              <div class="flex items-center gap-2">
                <input type="hidden" name="user[company][links_sort][]" value={links_form.index} />
                <.field
                  wrapper_class="col-span-2"
                  type="select"
                  field={links_form[:type]}
                  label="Tipo"
                  options={@url_types}
                  required
                />
                <.field
                  wrapper_class="flex-1"
                  type="text"
                  field={links_form[:url]}
                  label="Url"
                  required
                />
                <.button
                  with_icon
                  color="danger"
                  type="button"
                  size="xs"
                  name="user[company][links_drop][]"
                  value={links_form.index}
                  phx-click={JS.dispatch("change")}
                >
                  <.icon name="hero-x-mark" class="w-4 h-4 " />
                </.button>
              </div>
            </.inputs_for>
            <.button
              with_icon
              color="info"
              type="button"
              size="xs"
              name="user[company][links_sort][]"
              value="new"
              phx-click={JS.dispatch("change")}
            >
              <.icon name="hero-plus" class="w-4 h-4" />
              {gettext_with_locale(
                @locale,
                gettext("register.button.add.socialnetwork")
              )}
            </.button>
            <input type="hidden" name="user[company][link_drop][]" />
          </div>
          <.button phx-disable-with="Saving...">Guardar</.button>
        </div>
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

    IO.inspect(company)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:agency_models, Catalogs.list_agency_models() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:towns, get_towns_by_country(company.country))
      |> assign(:phone_start_number, nil)
      |> assign_phone_number(company.country)
      |> assign_form(changeset)
      |> assign(:url_types, [
        {"Web", "website"},
        {"Facebook", "facebook"},
        {"Instagram", "instagram"},
        {"Tiktok", "tiktok"}
      ])
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
         )
         |> IO.inspect() do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, gettext("prereister.updated"))
         |> push_navigate(to: ~p"/company")}

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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_phone_number(socket, country) do
    country =
      Countries.get(country)

    if country.country_code != socket.assigns.phone_start_number do
      socket
      |> push_event("update-input-phone", %{
        country_code: country.alpha2,
        start_number: country.country_code
      })
      |> assign(:phone_start_number, country.country_code)
    else
      socket
    end
    |> assign(:phone_start_number, country.country_code)
  end
end
