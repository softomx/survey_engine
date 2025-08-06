defmodule SurveyEngineWeb.SurveyReponseLive.Index do
  alias SurveyEngine.Accounts
  alias SurveyEngine.LeadsForms
  alias SurveyEngine.Responses
  alias SurveyEngine.Responses.SurveyResponse
  alias SurveyEngine.TransaleteHelper
  alias PetalFramework.Components.DataTable
  use SurveyEngineWeb, :live_view

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :date],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :state, :form_group_id, :date, :user_id],
    filterable: [:id, :form_group_id, :state, :date, :user_id]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :index_params, nil) |> assign(:meta, %Flop.Meta{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    from_groups = LeadsForms.list_form_groups()
    users = Accounts.list_users()

    socket
    |> assign(:page_title, "Listado de respuestas")
    |> assign(:company, nil)
    |> assign(:from_groups, from_groups)
    |> assign(:users, users)
    |> assign_survey_answers(params)
    |> assign(:index_params, params)
  end

  @impl true
  def handle_event("submit-filter", %{"filter" => params}, %{assigns: _assigns} = socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/survey_answers?#{params}")}
  end

  @impl true
  def handle_event("reset-filter", _, %{assigns: _assigns} = socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/survey_answers")}
  end

  @impl true
  def handle_event("sync_external_responses", _, socket) do

    LeadsForms.list_leads_forms(%{filter: %{active: true}})
    |> Enum.each(fn survey ->
      case survey.provider do
        "formbricks" ->
          %SurveyEngine.Responses.FormBricks{data: %{survey: survey}, event: "sync", site_config_id: socket.assigns.site_config.id}
          |> SurveyEngine.Responses.ExternalSurveyEngine.reprocess_all_responses()
        end
      end)
    {:noreply, socket |> assign_survey_answers(socket.assigns.index_params)}
  end

  defp assign_survey_answers(socket, params) do
    starting_query = SurveyResponse
    {responses, meta} = DataTable.search(starting_query, params, @data_table_opts)

    responses = responses |> Responses.list_survey_responses_with_preloads()
    assign(socket, survey_reponse: responses, meta: meta)
  end
end
