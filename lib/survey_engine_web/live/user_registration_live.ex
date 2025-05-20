defmodule SurveyEngineWeb.UserRegistrationLive do
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-10 px-10">
      <div class="mx-auto max-w-3xl">
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
                  phx-click={
                    JS.push("change-language", target: @myself, value: %{value: language.slug})
                  }
                  label={language.name}
                />
              <% end %>
            </.dropdown>
          </div>
          <.live_component
            id="form"
            module={SurveyEngineWeb.EmbedLive.FormComponent}
            locale={@locale}
            currencies={@currencies}
            user={@user}
            list_languages={@languages}
            agency_types={@agency_types}
            agency_models={@agency_models}
            countries={@countries}
            site_config={@site_config}
          />
        </div>
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800"></div>
      </div>
      <.modal :if={@show_modal}>
        <.live_component
          module={SurveyEngineWeb.EmbedLive.AgencyDescriptionComponent}
          id={:modal_show}
          action={@live_action}
          items={@modal_content}
          language={@locale}
          glossary_type={@glossary_type}
        />
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
      |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
      |> assign(:agency_types, Catalogs.list_agency_types_with_preload())
      |> assign(:agency_models, Catalogs.list_agency_models_with_preload())
      |> assign(:towns, [])
      |> assign(:user, %User{})
      |> assign(:languages, list_languages)
      |> assign(:show_modal, false)

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
