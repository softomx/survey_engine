defmodule SurveyEngineWeb.TranslationLive.Index do
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
         %{"type" => type, "behaviour" => behaviour, "resource_id" => resource_id} = params
       ) do
    socket
    |> assign(:page_title, build_page_title(params))
    |> assign(:translation, nil)
    |> assign_translations(params)
    |> assign(:index_params, params)
    |> assign(:resource_id, resource_id)
    |> assign(:type, type)
    |> assign(:behaviour, behaviour)
  end

  defp assign_translations(
         socket,
         %{"type" => type, "resource_id" => resource_id, "behaviour" => behaviour} = params
       ) do
    starting_query =
      Translations.translations_filter_with(Translation, %{
        resource_id: resource_id,
        type: type,
        behaviour: behaviour
      })

    {translations, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, translations: translations, meta: meta)
  end

  defp build_page_title(%{"type" => type, "behaviour" => behaviour}) do
    cond do
      type == "site_configurations" and behaviour == "goals" ->
        "Objetivos"

      type == "site_configurations" and behaviour == "scopes" ->
        "Alcances"

      type == "site_configurations" and behaviour == "policies" ->
        "Politicas"

      type == "agency_types" and behaviour == "description" ->
        "Descipcio de agencia"

      true ->
        "Listado"
    end
  end

  defp build_new_button_text(%{"type" => type, "behaviour" => behaviour}) do
    cond do
      type == "site_configurations" and behaviour == "goals" ->
        "Nuevo objetivo"

      type == "site_configurations" and behaviour == "scopes" ->
        "Nuevo alcance"

      type == "agency_types" and behaviour == "description" ->
        "Nueva descripcion"

      type == "site_configurations" and behaviour == "policies" ->
        "Nueva Politica"

      true ->
        "Nuevo"
    end
  end
end
