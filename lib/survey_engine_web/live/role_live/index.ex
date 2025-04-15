defmodule SurveyEngineWeb.RoleLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts
  alias SurveyEngine.Accounts.Role
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
    |> assign(:page_title, "Edit Role")
    |> assign(:role, Accounts.get_role!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Role")
    |> assign(:role, %Role{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign_roles(params)
    |> assign(index_params: params)
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/roles")}
  end

  @impl true
  def handle_event("update_filters",  %{"filters" => filter_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/roles?#{filter_params}")}
  end

  defp assign_roles(socket, params) do
    starting_query = Role
    {roles, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, roles: roles, meta: meta)
  end
end
