defmodule SurveyEngineWeb.SurveyResponseLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Responses

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

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey_responses/#{socket.assigns.survey_response}")}
  end

  defp page_title(:show), do: "Show Survey response"
  defp page_title(:edit), do: "Edit Survey response"
end
