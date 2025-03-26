defmodule SurveyEngineWeb.PersonalTitleLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Catalogs
  alias SurveyEngine.Catalogs.PersonalTitle
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
    |> assign(:page_title, "Edit Personal title")
    |> assign(:personal_title, Catalogs.get_personal_title!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Personal title")
    |> assign(:personal_title, %PersonalTitle{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Personal titles")
    |> assign_personal_titles(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/admin/catalogs/personal_titles?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/admin/catalogs/personal_titles?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    personal_title = Catalogs.get_personal_title!(id)
    {:ok, _} = Catalogs.delete_personal_title(personal_title)

    socket =
      socket
      |> assign_personal_titles(socket.assigns.index_params)
      |> put_flash(:info, "Personal title deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_personal_titles(socket, params) do
    starting_query = PersonalTitle
    {personal_titles, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, personal_titles: personal_titles, meta: meta)
  end
end
