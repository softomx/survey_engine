defmodule SurveyEngineWeb.NotificationLive.FormComponent do
  alias SurveyEngine.Notifications.NotificationTo
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Notifications

  @impl true
  def update(%{notification: notification} = assigns, socket) do
    changeset = Notifications.change_notification(notification)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:emails, notification.to)}
  end

  @impl true
  def handle_event("validate", %{"notification" => notification_params}, socket) do
    changeset =
      socket.assigns.notification
      |> Notifications.change_notification(notification_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"notification" => notification_params}, socket) do
    save_notification(socket, socket.assigns.action, notification_params)
  end

  defp save_notification(socket, :edit, notification_params) do
    case Notifications.update_notification(socket.assigns.notification, notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_notification(socket, :new, notification_params) do
    case Notifications.create_notification(notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
