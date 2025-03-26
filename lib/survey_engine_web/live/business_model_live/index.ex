defmodule SurveyEngineWeb.BusinessModelLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.BusinessModels
  alias SurveyEngine.BusinessModels.BusinessModel
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :name, :slug],
    filterable: [:id, :inserted_at, :name, :slug]
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
    |> assign(:page_title, "Edit Business model")
    |> assign(:business_model, BusinessModels.get_business_model!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Business model")
    |> assign(:business_model, %BusinessModel{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Business models")
    |> assign_business_models(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/admin/catalogs/business_models?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/admin/catalogs/business_models?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    business_model = BusinessModels.get_business_model!(id)
    {:ok, _} = BusinessModels.delete_business_model(business_model)

    socket =
      socket
      |> assign_business_models(socket.assigns.index_params)
      |> put_flash(:info, "Business model deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_business_models(socket, params) do
    starting_query = BusinessModel
    {business_models, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, business_models: business_models, meta: meta)
  end
end
