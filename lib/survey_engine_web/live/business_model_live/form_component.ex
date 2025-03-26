defmodule SurveyEngineWeb.BusinessModelLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.BusinessModels

  @impl true
  def update(%{business_model: business_model} = assigns, socket) do
    changeset = BusinessModels.change_business_model(business_model)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"business_model" => business_model_params}, socket) do
    changeset =
      socket.assigns.business_model
      |> BusinessModels.change_business_model(business_model_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"business_model" => business_model_params}, socket) do
    save_business_model(socket, socket.assigns.action, business_model_params)
  end

  defp save_business_model(socket, :edit, business_model_params) do
    case BusinessModels.update_business_model(socket.assigns.business_model, business_model_params) do
      {:ok, _business_model} ->
        {:noreply,
         socket
         |> put_flash(:info, "Business model updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_business_model(socket, :new, business_model_params) do
    case BusinessModels.create_business_model(business_model_params) do
      {:ok, _business_model} ->
        {:noreply,
         socket
         |> put_flash(:info, "Business model created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
