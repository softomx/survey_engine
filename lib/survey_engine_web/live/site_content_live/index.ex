defmodule SurveyEngineWeb.SiteContentLive.Index do
  alias PetalFramework.Components.DataTable
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations
  alias SurveyEngine.Translations.Translation

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at],
    filterable: [:id, :inserted_at]
  ]
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
         socket,
         :index,
         %{"behaviour" => behaviour} = params
       ) do
    socket
    |> assign(:page_title, build_page_title(params))
    |> assign(:translation, nil)
    |> assign_translations(params)
    |> assign(:index_params, params)
    |> assign(:resource_id, socket.assigns.site_config.id)
    |> assign(:type, "site_configurations")
    |> assign(:behaviour, behaviour)
  end

  defp assign_translations(
         socket,
         %{"behaviour" => behaviour} = params
       ) do
    starting_query =
      Translations.translations_filter_with(Translation, %{
        resource_id: socket.assigns.site_config.id,
        type: "site_configurations",
        behaviour: behaviour
      })

    {translations, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, translations: translations, meta: meta)
  end

  defp build_page_title(%{"behaviour" => behaviour}) do
    cond do
      behaviour == "goals" ->
        "Objetivos"

      behaviour == "scopes" ->
        "Alcances"

      behaviour == "policies" ->
        "Politicas"

      true ->
        ""
    end
  end

  defp build_new_button_text(%{"behaviour" => behaviour}) do
    cond do
      behaviour == "goals" ->
        "Nuevo objetivo"

      behaviour == "scopes" ->
        "Nuevo alcance"

      behaviour == "policies" ->
        "Nueva Politica"
    end
  end
end
