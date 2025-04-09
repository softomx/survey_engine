defmodule SurveyEngineWeb.PermissionActionLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Permissions
  alias SurveyEngine.Permissions.PermissionAction
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 30,
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
    |> assign(:page_title, "Editar permiso")
    |> assign(:permission_action, Permissions.get_permission_action!(id))
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign_permissions_actions(params)
    |> assign(index_params: params)
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/permissions_actions")}
  end

  @impl true
  def handle_event("update_filters",  %{"filters" => filter_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/permissions_actions?#{filter_params}")}
  end

  defp assign_permissions_actions(socket, params) do
    starting_query = PermissionAction
    {permissions_actions, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, permissions_actions: permissions_actions, meta: meta)
  end
end
