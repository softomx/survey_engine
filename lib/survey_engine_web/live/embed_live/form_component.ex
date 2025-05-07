defmodule SurveyEngineWeb.EmbedLive.FormComponent do
  alias SurveyEngine.Accounts.User
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.Accounts
  use SurveyEngineWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800">
      <.header class="text-center">
        {gettext_with_locale(@locale, gettext("register.form.title"))}

        <:subtitle>
          {gettext_with_locale(@locale, gettext("Already registered?"))}

          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            {gettext_with_locale(@locale, gettext("Log in"))}
          </.link>
        </:subtitle>
      </.header>

      <div class="flex flex-row justify-end py-5">
        <.dropdown label={"Language (#{@locale})"}>
          <%= for language <- @list_languages |> Enum.reject(&(&1.slug == @locale)) do %>
            <.dropdown_menu_item
              phx-click={JS.push("change-language", target: @myself, value: %{value: language.slug})}
              label={language.name}
            />
          <% end %>
        </.dropdown>
      </div>
      <.form
        for={@form}
        id="registration_form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          {gettext("Oops, something went wrong! Please check the errors below.")}
        </.error>
        <div class="grid grid-cols-12 sm:grid-cols-6 lg:grid-cols-6 gap-6 pb-5">
          <.inputs_for :let={f2} field={@form[:company]}>
            <.field field={f2[:date]} type="hidden" value={Timex.today()} />
            <.field field={f2[:language]} type="hidden" value={@locale} />
            <div class="col-span-12 lg:col-span-12 md:col-span-12">
              <.field
                field={f2[:legal_name]}
                type="text"
                label={gettext_with_locale(@locale, gettext("label.fullname"))}
                required
              />
            </div>
            <div class="col-span-12 lg:col-span-12 md:col-span-12">
              <.field
                field={@form[:email]}
                type="email"
                placeholder={gettext_with_locale(@locale, gettext("placeholder.email"))}
                label={gettext_with_locale(@locale, gettext("label.email"))}
                required
              />
            </div>

            <div class="col-span-12 lg:col-span-12 md:col-span-12">
              <.field
                field={f2[:country]}
                type="select"
                prompt={gettext_with_locale(@locale, gettext("placeholder.select.country"))}
                label={gettext_with_locale(@locale, gettext("country"))}
                options={@countries}
                required
              />
            </div>
            <div class="col-span-12 lg:col-span-6 md:col-span-6">
              <.field
                field={f2[:town]}
                type="select"
                label={gettext_with_locale(@locale, gettext("label.state"))}
                prompt={gettext_with_locale(@locale, gettext("placeholder.select.state"))}
                options={@towns}
                required
              />
            </div>
            <div class="col-span-12 lg:col-span-6 md:col-span-6">
              <.field
                field={f2[:city]}
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
                field={f2[:phone]}
                phx-update="ignore"
                phx-hook="PhoneInput"
                data-country={Phoenix.HTML.Form.input_value(f2, :country)}
                data-start-number={@phone_start_number}
                type="text"
                required
              />
            </div>
            <div class="col-span-12 lg:col-span-6 md:col-span-4">
              <.field
                field={f2[:billing_currency]}
                prompt={gettext_with_locale(@locale, gettext("placeholder.select.billing.currency"))}
                type="select"
                label={gettext_with_locale(@locale, gettext("label.billing.currency"))}
                options={@currencies}
                required
              />
            </div>
            <div class="col-span-9 lg:col-span-8 md:col-span-8">
              <.field
                field={f2[:agency_type]}
                prompt={gettext_with_locale(@locale, gettext("placeholder.select.agency.type"))}
                type="select"
                options={@agency_types}
                label={gettext_with_locale(@locale, gettext("agency.type"))}
                required
              />
            </div>
            <div class="col-span-3 lg:col-span-4 md:col-span-4 justify-start  flex items-center  text-blue-500">
              <span
                class="hover:underline py-1  text-left text-xs cursor-pointer "
                phx-click={JS.push("show_glossary", target: @myself, value: %{type: "agency_type"})}
              >
                {gettext_with_locale(@locale, gettext("agencytype.glossary"))}
              </span>
            </div>
            <div class="col-span-12 lg:col-span-6 md:col-span-4">
              <.field
                field={f2[:agency_model]}
                prompt={gettext_with_locale(@locale, gettext("placeholder.select.agency.model"))}
                type="select"
                options={@agency_models}
                label={gettext_with_locale(@locale, gettext("agency.model"))}
                required
              />
            </div>
            <div class="col-span-3 lg:col-span-4 md:col-span-4 justify-start  flex items-center  text-blue-500">
              <span
                class="hover:underline py-1  text-left text-xs cursor-pointer "
                phx-click={JS.push("show_glossary", target: @myself, value: %{type: "agency_model"})}
              >
                {gettext_with_locale(@locale, gettext("agencymodel.glossary"))}
              </span>
            </div>
            <div class="col-span-3 lg:col-span-3 md:col-span-3 self-center"></div>
            <div class="col-span-12">
              <label>{gettext("socialnetwork.title")}</label>
              <input type="hidden" name="user[company][link_drop][]" />
              <.inputs_for :let={links_form} field={f2[:links]}>
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
                    type="url"
                    pattern="https://.*"
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
          </.inputs_for>
        </div>
        <.button phx-disable-with="Creating account..." class="w-full">
          {gettext_with_locale(@locale, gettext("Create an account"))}
        </.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset =
      Accounts.change_user_registration(user, %{company: %{language: assigns.locale}})

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)
      |> assign(:towns, [])
      |> assign(:phone_start_number, 52)
      |> assign(:url_types, [
        {"Sitio web", "website"},
        {"Facebook", "facebook"},
        {"Instagram", "instagram"},
        {"Tiktok", "tiktok"}
      ])
    }
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration_with_company(%User{}, user_params)
    towns = get_towns_by_country(user_params["company"]["country"])

    socket =
      assign_form(socket, Map.put(changeset, :action, :validate))
      |> assign(towns: towns)
      |> assign(user_params: user_params)
      |> assign_phone_number(user_params["company"]["country"])

    {:noreply, socket}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user_with_company(user_params |> IO.inspect()) do
      {:ok, user} ->
        {:ok, _} =
          NotificationManager.register_lead_notification(
            user,
            socket.assigns.site_config,
            &url(~p"/users/confirm/#{&1}")
          )

        Accounts.set_user_cllient_role(user)

        changeset = Accounts.change_user_registration_with_company(user)
        send(self(), {:put_flash, :info, gettext("register.complete.message")})

        {:noreply,
         socket
         #  |> assign(trigger_submit: true)
         |> assign_form(changeset)
         |> put_flash(:info, gettext("register.complete.message"))
         |> push_navigate(to: ~p"/users/sucess_register?locale=#{socket.assigns.locale}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  @impl true
  def handle_event("change-language", %{"value" => value}, socket) do
    Gettext.put_locale(SurveyEngineWeb.Gettext, value)

    {:noreply,
     socket
     |> assign(locale: value)}
  end

  def handle_event("show_glossary", %{"type" => type} = _params, socket) do
    notify_parent({"show_glossary", type})
    {:noreply, socket}
  end

  defp get_towns_by_country(nil), do: []
  defp get_towns_by_country(""), do: []

  defp get_towns_by_country(country) do
    country =
      Countries.filter_by(:alpha2, country)
      |> List.first()

    country
    |> Countries.Subdivisions.all()
    |> Enum.filter(&(&1.name != nil))
    |> Enum.map(&{&1.name, &1.name})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp assign_phone_number(socket, nil), do: socket
  defp assign_phone_number(socket, ""), do: socket

  defp assign_phone_number(socket, country) do
    country =
      Countries.get(country)

    if country.country_code != socket.assigns.phone_start_number do
      socket
      |> push_event("update-input-phone", %{
        country_code: country.alpha2,
        start_number: country.country_code
      })
    else
      socket
    end
    |> assign(:phone_start_number, country.country_code)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
