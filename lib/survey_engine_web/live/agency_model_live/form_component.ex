defmodule SurveyEngineWeb.AgencyModelLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Catalogs

  @impl true
  def update(%{agency_model: agency_model} = assigns, socket) do
    changeset = Catalogs.change_agency_model(agency_model)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"agency_model" => agency_model_params}, socket) do
    changeset =
      socket.assigns.agency_model
      |> Catalogs.change_agency_model(agency_model_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"agency_model" => agency_model_params}, socket) do
    save_agency_model(socket, socket.assigns.action, agency_model_params)
  end

  defp save_agency_model(socket, :edit, agency_model_params) do
    case Catalogs.update_agency_model(socket.assigns.agency_model, agency_model_params) do
      {:ok, _agency_model} ->
        {:noreply,
         socket
         |> put_flash(:info, "Agency model updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_agency_model(socket, :new, agency_model_params) do
    case Catalogs.create_agency_model(agency_model_params) do
      {:ok, _agency_model} ->
        {:noreply,
         socket
         |> put_flash(:info, "Agency model created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
