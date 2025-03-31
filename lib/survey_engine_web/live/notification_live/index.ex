defmodule SurveyEngineWeb.NotificationLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Notifications
  alias SurveyEngine.Notifications.Notification
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :action, :to, :from, :from_name, :subject, :content],
    filterable: [:id, :inserted_at, :action, :to, :from, :from_name, :subject, :content]
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
    |> assign(:page_title, "Edit Notification")
    |> assign(:notification, Notifications.get_notification!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Notification")
    |> assign(:notification, %Notification{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Notifications")
    |> assign_notifications(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/admin/notifications?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", %{"filters" => filter_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/notifications?#{filter_params}")}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_notifications(socket, params) do
    starting_query = Notification
    {notifications, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, notifications: notifications, meta: meta)
  end
end
