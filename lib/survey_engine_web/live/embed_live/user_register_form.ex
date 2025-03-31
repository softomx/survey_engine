defmodule SurveyEngineWeb.EmbedLive.UserRegisterForm do
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts
  alias SurveyEngine.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    default_language = Map.get(params, "locale", "es")
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]
    list_agency_desciptions = Catalogs.list_agency_types_with_preload()

    changeset =
      Accounts.change_user_registration(%User{}, %{company: %{language: default_language}})

    socket
    |> assign(trigger_submit: false, check_errors: false)
    |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
    |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
    |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
    |> assign_form(changeset)
    |> assign(:towns, [])
    |> assign(language: default_language)
    |> assign(list_languages: list_languages)
    |> assign(list_agency_desciptions: list_agency_desciptions)
    |> assign(:index_params, params)

    # {:ok, socket, temporary_assigns: [form: nil]}
  end

  defp apply_action(socket, :modal_show, params) do
    default_language = Map.get(params, "locale", "es")
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]
    list_agency_desciptions = Catalogs.list_agency_types_with_preload()

    changeset =
      Accounts.change_user_registration(%User{}, %{company: %{language: default_language}})

    socket
    |> assign(trigger_submit: false, check_errors: false)
    |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
    |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
    |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
    |> assign_form(changeset)
    |> assign(:towns, [])
    |> assign(language: default_language)
    |> assign(list_languages: list_languages)
    |> assign(list_agency_desciptions: list_agency_desciptions)
    |> assign(:index_params, params)

    # {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("change-language", %{"value" => value}, socket) do
    user_params = Map.get(socket.assigns, :user_params, %{"company" => %{}})
    add_new_language_params = Map.put(user_params["company"], "language", value)
    new_user_params = Map.merge(user_params, %{"company" => add_new_language_params})

    changeset =
      Accounts.change_user_registration_with_company(%User{}, new_user_params)

    towns = get_towns_by_country(new_user_params["company"]["country"])

    socket =
      assign_form(socket, Map.put(changeset, :action, :validate))
      |> assign(towns: towns)
      |> assign(user_params: new_user_params)

    Gettext.put_locale(SurveyEngineWeb.Gettext, value)

    {:noreply,
     socket
     |> assign(language: value)}
  end

  @impl true

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
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration_with_company(%User{}, user_params)
    towns = get_towns_by_country(user_params["company"]["country"])

    socket =
      assign_form(socket, Map.put(changeset, :action, :validate))
      |> assign(towns: towns)
      |> assign(user_params: user_params)

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     push_patch(socket,
       to: current_index_path(socket.assigns.index_params, socket.assigns.language)
     )}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp current_index_path(index_params, language) do
    ~p"/embed/users/register/form/#{language}/?#{index_params || %{}}"
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

  defp get_text_with_locale(locale, funtion) do
    Gettext.with_locale(SurveyEngineWeb.Gettext, locale, fn ->
      funtion
    end)
  end
end
