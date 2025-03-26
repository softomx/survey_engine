defmodule SurveyEngineWeb.SurveyResponseLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Responses

  @impl true
  def update(%{survey_response: survey_response} = assigns, socket) do
    changeset = Responses.change_survey_response(survey_response)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"survey_response" => survey_response_params}, socket) do
    changeset =
      socket.assigns.survey_response
      |> Responses.change_survey_response(survey_response_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"survey_response" => survey_response_params}, socket) do
    save_survey_response(socket, socket.assigns.action, survey_response_params)
  end

  defp save_survey_response(socket, :edit, survey_response_params) do
    case Responses.update_survey_response(socket.assigns.survey_response, survey_response_params) do
      {:ok, _survey_response} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey response updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_survey_response(socket, :new, survey_response_params) do
    case Responses.create_survey_response(survey_response_params) do
      {:ok, _survey_response} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey response created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
