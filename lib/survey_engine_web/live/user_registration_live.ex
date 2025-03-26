defmodule SurveyEngineWeb.UserRegistrationLive do
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts
  alias SurveyEngine.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.field field={@form[:email]} type="email" label="Email" required />

        <.inputs_for :let={f2} field={@form[:company]}>
          <div>
            <.field field={f2[:date]} type="hidden" value={Timex.today()} />
            <.combo_box
              field={f2[:language]}
              type="select"
              label="Language"
              placeholder="Selecciona un lenguage"
              options={[{"Español", "es"}, {"Ingles", "en"}]}
            />
            <.field field={f2[:legal_name]} type="text" label="Legal name" />
            <.combo_box
              field={f2[:country]}
              type="select"
              placeholder="Selecciona el pais"
              label="Country"
              options={@countries}
            />
            <.combo_box
              field={f2[:town]}
              type="select"
              label="Town"
              placeholder="Selecciona el estado"
              options={@towns}
            />
            <.field field={f2[:city]} type="text" label="City" />
            <.combo_box
              field={f2[:agency_type]}
              placeholder="Selecciona el tipo de agencia"
              type="select"
              options={@agency_types}
              label="Agency type"
            />
            <.combo_box
              field={f2[:billing_currency]}
              placeholder="Selecciona una moneda de facturacion"
              type="select"
              label="Billing currency"
              options={@currencies}
            />
          </div>
        </.inputs_for>

        <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
      |> assign_form(changeset)
      |> assign(:towns, [])

    {:ok, socket, temporary_assigns: [form: nil]}
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

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration_with_company(%User{}, user_params)
    towns = get_towns_by_country(user_params["company"]["country"])

    socket =
      assign_form(socket, Map.put(changeset, :action, :validate))
      |> assign(towns: towns)

    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
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
end
