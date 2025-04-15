defmodule SurveyEngineWeb.SurveyResponseLive.EditComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Responses

  @impl true
  def update(%{survey_response_item: survey_response_item} = assigns, socket) do
    response_item_info =
      Map.get(assigns.external_form.questions, survey_response_item.question_id, %{})
    {:ok,
     socket
     |> assign(:response_item_info, response_item_info)
     |> assign(assigns)}
  end

  @impl true
  def handle_event("save", %{"response_item" => response_item}, socket) do
    data =
      case socket.assigns.survey_response_item.type  do
        "date" ->
          response_item["date"]
        "openText" ->
          response_item["open_text"]
        "multipleChoiceMulti" ->
          response_item["choice_multiple"]
        "multipleChoiceSingle" ->
          response_item["choice_single"]
        _ -> socket.assigns.survey_response_item.answer["data"]
      end
    save_survey_response(socket, socket.assigns.action, %{"answer" => %{"data" => data}})
  end

  def handle_event("remove_file", %{"url" => file_url}, socket) do
    data =
      socket.assigns.survey_response_item.answer["data"]
      |> Enum.reject(fn file -> file["url"] == file_url end)

    save_survey_response(socket, socket.assigns.action, %{"answer" => %{"data" => data}})
  end

  defp save_survey_response(socket, :edit_response_item, survey_response_params) do
    case Responses.update_survey_response_item(socket.assigns.survey_response_item, survey_response_params) |> IO.inspect() do
      {:ok, _survey_response} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey response updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
end


end
