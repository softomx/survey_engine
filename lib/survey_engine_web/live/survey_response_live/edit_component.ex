defmodule SurveyEngineWeb.SurveyResponseLive.EditComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Responses
  alias SurveyEngine.Responses.SurveyResponseAnswerEdit
  @impl true
  def update(%{survey_response_item: survey_response_item} = assigns, socket) do
    response_item_info =
      Map.get(assigns.external_form.questions, survey_response_item.question_id, %{})

    {:ok,
     socket
     |> assign(:response_item_info, response_item_info)
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(init_changeset(survey_response_item))
     end)}
  end

  @impl true
  def handle_event("validate", %{"survey_response_answer_edit" => params}, socket) do
    changeset =
      SurveyResponseAnswerEdit.changeset(
        %SurveyResponseAnswerEdit{},
        params,
        socket.assigns.survey_response_item.type
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"survey_response_answer_edit" => response_item}, socket) do
    data =
      case socket.assigns.survey_response_item.type do
        "date" ->
          response_item["date"]

        "openText" ->
          response_item["open_text"]

        "multipleChoiceMulti" ->
          response_item["choice_multiple"]

        "multipleChoiceSingle" ->
          response_item["choice_single"]

        _ ->
          socket.assigns.survey_response_item.answer["data"]
      end

    save_survey_response(socket, socket.assigns.action, %{
      "answer" => %{"data" => data},
      "editor_user_id" => socket.assigns.current_user.id
    })
  end

  def handle_event("remove_file", %{"url" => file_url}, socket) do
    data =
      socket.assigns.survey_response_item.answer["data"]
      |> Enum.reject(fn file -> file["url"] == file_url end)

    save_survey_response(socket, socket.assigns.action, %{
      "answer" => %{"data" => data},
      "editor_user_id" => socket.assigns.current_user.id
    })
  end

  defp save_survey_response(socket, :edit_response_item, survey_response_params) do
    case Responses.update_survey_response_item(
           socket.assigns.survey_response_item,
           survey_response_params
         ) do
      {:ok, _survey_response} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey response updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  defp init_changeset(survey_response_item) do
    params =
      case survey_response_item.type do
        "date" ->
          %{date: survey_response_item.answer["data"]}

        "openText" ->
          %{open_text: survey_response_item.answer["data"]}

        "multipleChoiceMulti" ->
          %{choice_multiple: survey_response_item.answer["data"]}

        "multipleChoiceSingle" ->
          %{choice_single: survey_response_item.answer["data"]}

        _ ->
          %{}
      end

    SurveyResponseAnswerEdit.changeset(
      %SurveyResponseAnswerEdit{},
      params,
      survey_response_item.type
    )
  end
end
