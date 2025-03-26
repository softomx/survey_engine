defmodule SurveyEngineWeb.PersonalTitleLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Catalogs

  @impl true
  def update(%{personal_title: personal_title} = assigns, socket) do
    changeset = Catalogs.change_personal_title(personal_title)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"personal_title" => personal_title_params}, socket) do
    changeset =
      socket.assigns.personal_title
      |> Catalogs.change_personal_title(personal_title_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"personal_title" => personal_title_params}, socket) do
    save_personal_title(socket, socket.assigns.action, personal_title_params)
  end

  defp save_personal_title(socket, :edit, personal_title_params) do
    case Catalogs.update_personal_title(socket.assigns.personal_title, personal_title_params) do
      {:ok, _personal_title} ->
        {:noreply,
         socket
         |> put_flash(:info, "Personal title updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_personal_title(socket, :new, personal_title_params) do
    case Catalogs.create_personal_title(personal_title_params) do
      {:ok, _personal_title} ->
        {:noreply,
         socket
         |> put_flash(:info, "Personal title created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
