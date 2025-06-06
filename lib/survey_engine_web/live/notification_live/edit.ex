defmodule SurveyEngineWeb.NotificationLive.Edit do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Notifications
  alias PetalFramework.Components.DataTable

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
    |> assign(:page_title, "Editar Configuracion de Notification")
    |> assign(:notification, Notifications.get_notification!(id))
  end

  defp current_index_path(index_params) do
    ~p"/admin/notifications?#{index_params}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/admin/notifications?#{query_params}")}
  end
end
