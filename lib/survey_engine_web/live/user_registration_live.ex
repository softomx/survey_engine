defmodule SurveyEngineWeb.UserRegistrationLive do
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-10 px-10">
      <div class="mx-auto max-w-3xl">
        <.live_component
          id="form"
          module={SurveyEngineWeb.EmbedLive.FormComponent}
          locale={@locale}
          currencies={@currencies}
          user={@user}
          list_languages={@languages}
          agency_types={@agency_types}
          countries={@countries}
          site_config={@site_config}
        />
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800"></div>
      </div>
      <.modal :if={@show_modal}>
        <.live_component
          module={SurveyEngineWeb.EmbedLive.AgencyDescriptionComponent}
          id={:modal_show}
          title={gettext("Description of Agencies")}
          action={@live_action}
          agencies={@list_agency_desciptions}
          language={@locale}
        />
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]
    list_agency_desciptions = Catalogs.list_agency_types_with_preload()

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types() |> Enum.map(&{&1.name, &1.name}))
      |> assign(:towns, [])
      |> assign(:user, %User{})
      |> assign(:languages, list_languages)
      |> assign(:show_modal, false)
      |> assign(list_agency_desciptions: list_agency_desciptions)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     assign(socket,
       show_modal: false
     )}
  end

  @impl true
  def handle_info({SurveyEngineWeb.EmbedLive.FormComponent, "show_glossary"}, socket) do
    {:noreply, socket |> assign(:show_modal, true)}
  end
end
