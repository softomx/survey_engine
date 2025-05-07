defmodule SurveyEngineWeb.AgencyModelLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Catalogs
  alias SurveyEngine.Catalogs.AgencyModel
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :name],
    filterable: [:id, :inserted_at, :name]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar modelo de agencia")
    |> assign(:agency_model, Catalogs.get_agency_model!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nuevo modelo de agencia")
    |> assign(:agency_model, %AgencyModel{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listado de modelos de agencia")
    |> assign_agency_models(params)
    |> assign(index_params: params)
    |> assign(:title, "Listado de modelos de agencia")
  end

  defp current_index_path(index_params) do
    ~p"/admin/catalogs/agency_models?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/admin/catalogs/agency_models?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    agency_model = Catalogs.get_agency_model!(id)
    {:ok, _} = Catalogs.delete_agency_model(agency_model)

    socket =
      socket
      |> assign_agency_models(socket.assigns.index_params)
      |> put_flash(:info, "Agency model deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_agency_models(socket, params) do
    starting_query = AgencyModel
    {agency_models, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, agency_models: agency_models, meta: meta)
  end
end
