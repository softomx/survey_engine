defmodule SurveyEngineWeb.FormGroupLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.LeadsForms

  @impl true
  def update(%{form_group: form_group} = assigns, socket) do
    changeset = LeadsForms.change_form_group(form_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"form_group" => form_group_params}, socket) do
    changeset =
      socket.assigns.form_group
      |> LeadsForms.change_form_group(form_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"form_group" => form_group_params}, socket) do
    save_form_group(socket, socket.assigns.action, form_group_params)
  end

  defp save_form_group(socket, :edit, form_group_params) do
    case LeadsForms.update_form_group(socket.assigns.form_group, form_group_params) do
      {:ok, _form_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form group updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_form_group(socket, :new, form_group_params) do
    case LeadsForms.create_form_group(form_group_params) do
      {:ok, _form_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form group created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
