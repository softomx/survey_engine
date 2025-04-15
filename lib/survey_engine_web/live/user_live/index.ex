defmodule SurveyEngineWeb.UserLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts.User
  alias SurveyEngine.Accounts
  alias SurveyEngine.Accounts.User
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

  defp apply_action(socket, :edit_roles, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user_with_preloads(id, :roles) do
      socket
      |> assign(:page_title, "Editar Roles Usuario")
      |> assign(:user, user)
    else
      _error -> socket
    end
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign_users(params)
    |> assign(index_params: params)
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/users")}
  end

  @impl true
  def handle_event("update_filters",  %{"filters" => filter_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/users?#{filter_params}")}
  end

  defp assign_users(socket, params) do
    starting_query = User
    {users, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, users: users, meta: meta)
  end
end
