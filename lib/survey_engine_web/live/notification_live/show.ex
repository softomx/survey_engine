defmodule SurveyEngineWeb.NotificationLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Notifications

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:notification, Notifications.get_notification!(id))}
  end

  defp page_title(:show), do: "Detalles de notificacion"
  defp page_title(:edit), do: "Edit Notification"
end
