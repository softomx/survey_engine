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
        {get_text_with_locale(@locale, gettext("Register for an account"))}

        <:subtitle>
          {get_text_with_locale(@locale, gettext("Already registered?"))}

          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            {get_text_with_locale(@locale, gettext("Log in"))}
          </.link>
          {get_text_with_locale(@locale, gettext("to your account now"))} .
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
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>
        <div class="grid grid-cols-1 sm:grid-cols-6 lg:grid-cols-6 gap-6 pb-5">
          <div class="col-span-3">
            <.field
              field={@form[:email]}
              type="email"
              label={get_text_with_locale(@locale, gettext("Email"))}
              required
            />
          </div>
          <.inputs_for :let={f2} field={@form[:company]}>
            <.field field={f2[:date]} type="hidden" value={Timex.today()} />
            <.field field={f2[:language]} type="hidden" value={@locale} />
            <div class="col-span-3">
              <.field
                field={f2[:legal_name]}
                type="text"
                label={get_text_with_locale(@locale, gettext("Legal name"))}
              />
            </div>
            <div class="col-span-3">
              <.combo_box
                field={f2[:country]}
                type="select"
                placeholder={get_text_with_locale(@locale, gettext("Select a country"))}
                label={get_text_with_locale(@locale, gettext("Country"))}
                options={@countries}
              />
            </div>
            <div class="col-span-3">
              <.combo_box
                field={f2[:town]}
                type="select"
                label={get_text_with_locale(@locale, gettext("Town"))}
                placeholder={get_text_with_locale(@locale, gettext("Select a town"))}
                options={@towns}
              />
            </div>
            <div class="col-span-3">
              <.field
                field={f2[:city]}
                type="text"
                label={get_text_with_locale(@locale, gettext("City"))}
              />
            </div>
            <div class="col-span-3">
              <.combo_box
                field={f2[:billing_currency]}
                placeholder={get_text_with_locale(@locale, gettext("Select a billing currency"))}
                type="select"
                label={get_text_with_locale(@locale, gettext("Billy Currency"))}
                options={@currencies}
              />
            </div>
            <div class="col-span-5">
              <.combo_box
                field={f2[:agency_type]}
                placeholder={get_text_with_locale(@locale, gettext("Select an agency"))}
                type="select"
                options={@agency_types}
                label={get_text_with_locale(@locale, gettext("Agency Type"))}
              />
            </div>
            <div class="col-span-1 self-center">
              <span
                class="pc-button pc-button--primary pc-button--md pc-button--radius-md w-full"
                phx-click={JS.push("show_glossary", target: @myself)}
              >
                {get_text_with_locale(@locale, gettext("Glossary"))}
              </span>
            </div>
          </.inputs_for>
        </div>
        <.button phx-disable-with="Creating account..." class="w-full">
          {get_text_with_locale(@locale, gettext("Create an account"))}
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

    # notify_parent(changeset)
    {:noreply, socket}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user_with_company(user_params) do
      {:ok, user} ->
        {:ok, _} =
          NotificationManager.register_lead_notification(
            user,
            socket.assigns.site_config,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration_with_company(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

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

  def handle_event("show_glossary", _params, socket) do
    notify_parent("show_glossary")
    {:noreply, socket}
  end

  defp get_text_with_locale(locale, funtion) do
    Gettext.with_locale(SurveyEngineWeb.Gettext, locale, fn ->
      funtion
    end)
  end

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
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
