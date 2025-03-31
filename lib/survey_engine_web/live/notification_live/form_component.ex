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
      |> IO.inspect(label: "skksksk")
      |> Notifications.change_notification(notification_params |> IO.inspect())
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"notification" => notification_params}, socket) do
    save_notification(socket, socket.assigns.action, notification_params)
  end

  def handle_event("add_to_email", _, socket) do
    # existing_to_emails =
    #   Ecto.Changeset.get_field(socket.assigns.form.source, :to, [])
    #   |> IO.inspect()
    #   |> Enum.map(fn i -> Map.from_struct(i) end)

    append_to_email =
      Notifications.change_notification(socket.assigns.notification, %{
        "to" => (socket.assigns.emails ++ [%{name: "", email: ""}]) |> IO.inspect()
      })

    up =
      append_to_email
      |> Ecto.Changeset.apply_changes()
      |> IO.inspect()

    {:noreply, assign(socket, emails: up.to, form: to_form(append_to_email))}
  end

  def handle_event("remove_to_email", %{"index" => index}, socket) do
    updated_to_emails =
      Ecto.Changeset.get_field(socket.assigns.form.source, :to, [])
      |> IO.inspect()
      |> List.delete_at(String.to_integer(index))
      |> Enum.map(fn i -> Map.from_struct(i) end)

    remove_to_email =
      Notifications.change_notification(socket.assigns.notification, %{
        "to" => updated_to_emails
      })

    {:noreply, assign(socket, form: to_form(remove_to_email))}
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
