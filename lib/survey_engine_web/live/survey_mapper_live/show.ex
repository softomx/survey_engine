defmodule SurveyEngineWeb.SurveyMapperLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SurveyMappers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:survey_mappers, SurveyMappers.list_survey_mapper!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey_mapper/#{socket.assigns.survey_mapper}")}
  end

  defp page_title(:show), do: "Show Survey mapper"
  defp page_title(:edit), do: "Edit Survey mapper"
end
