defmodule SurveyEngineWeb.SurveyResponseLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Responses
  alias SurveyEngine.TransaleteHelper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:survey_response, Responses.get_survey_response!(id))}
  end

  def handle_event("update_review_state", %{"state" => state}, socket) do
    survey_response = socket.assigns.survey_response

    case Responses.update_survey_response(survey_response, %{review_state: state}) do
      {:ok, _survey_response} ->
        {:noreply,
         socket
         |> push_patch(to: ~p"/survey_responses/#{survey_response.id}")}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey_responses/#{socket.assigns.survey_response}")}
  end

  defp page_title(:show), do: "Show Survey response"
  defp page_title(:edit), do: "Edit Survey response"
end
