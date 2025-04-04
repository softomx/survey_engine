defmodule SurveyEngineWeb.SurveyMapperLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.SurveyMappers

  @impl true
  def update(%{survey_mapper: survey_mapper} = assigns, socket) do
    IO.inspect(survey_mapper, label: "Survey Mapper")
    changeset = SurveyMappers.change_survey_mapper(survey_mapper)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"survey_mapper" => survey_mapper_params}, socket) do
    changeset =
      socket.assigns.survey_mapper
      |> SurveyMappers.change_survey_mapper(survey_mapper_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"survey_mapper" => survey_mapper_params}, socket) do
    save_survey_mapper(socket, socket.assigns.action, survey_mapper_params)
  end

  defp save_survey_mapper(socket, :edit, survey_mapper_params) do
    case SurveyMappers.update_survey_mapper(socket.assigns.survey_mapper, survey_mapper_params) do
      {:ok, _survey_mapper} ->
        send(self(), {:put_flash, :info, "Survey mapper updated successfully"})

        {
          :noreply,
          socket
          |> put_flash(:info, "Survey mapper updated successfully")
          #  |> push_navigate(to: socket.assigns.return_to)}
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_survey_mapper(socket, :new, survey_mapper_params) do
    case SurveyMappers.create_survey_mapper(survey_mapper_params) do
      {:ok, _survey_mapper} ->
        send(self(), {:put_flash, :info, "Survey mapper created successfully"})

        {
          :noreply,
          socket
          |> put_flash(:info, "Survey mapper created successfully")
          #  |> push_navigate(to: socket.assigns.return_to)}
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
