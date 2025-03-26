defmodule SurveyEngineWeb.SurveyResponseLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Responses
  alias SurveyEngine.Responses.SurveyResponse
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :date, :state, :data],
    filterable: [:id, :inserted_at, :date, :state, :data]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Survey response")
    |> assign(:survey_response, Responses.get_survey_response!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Survey response")
    |> assign(:survey_response, %SurveyResponse{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Survey responses")
    |> assign_survey_responses(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/survey_responses?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/survey_responses?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    survey_response = Responses.get_survey_response!(id)
    {:ok, _} = Responses.delete_survey_response(survey_response)

    socket =
      socket
      |> assign_survey_responses(socket.assigns.index_params)
      |> put_flash(:info, "Survey response deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_survey_responses(socket, params) do
    starting_query = SurveyResponse
    {survey_responses, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, survey_responses: survey_responses, meta: meta)
  end
end
