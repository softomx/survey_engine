defmodule SurveyEngineWeb.EmbedLive.UserRegisterForm do
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:show_modal, false)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]
    list_agency_desciptions = Catalogs.list_agency_types_with_preload()

    socket
    |> assign(trigger_submit: false, check_errors: false)
    |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
    |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
    |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
    |> assign(:agency_models, Catalogs.list_agency_models() |> Enum.map(&{&1.name, &1.name}))
    |> assign(list_languages: list_languages)
    |> assign(list_agency_desciptions: list_agency_desciptions)
    |> assign(:user, %User{})
  end

  @impl true
  def handle_info(
        {SurveyEngineWeb.EmbedLive.FormComponent, {"show_glossary", glossary_type}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:glossary_type, glossary_type)
     |> assign_modal_content(glossary_type)}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     assign(socket,
       show_modal: false
     )}
  end

  defp assign_modal_content(socket, glossary_type) do
    case glossary_type do
      "agency_type" ->
        socket
        |> assign(:modal_content, socket.assigns.agency_types)

      "agency_model" ->
        socket
        |> assign(:modal_content, socket.assigns.agency_models)
    end
  end
end
