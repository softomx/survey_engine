defmodule SurveyEngineWeb.SurveyMapperLive.Index do
  alias SurveyEngine.AffiliateEngine.Affiliate
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SurveyMappers
  alias SurveyEngine.SurveyMappers.SurveyMapper
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :field, :question_id, :type],
    filterable: [:id, :inserted_at, :field, :question_id, :type]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil) |> assign(:items, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Survey mapper")
    |> assign(:survey_mapper, SurveyMappers.get_survey_mapper!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Survey mapper")
    |> assign(:survey_mapper, %SurveyMapper{})
  end

  defp apply_action(socket, :index, params) do
    lead_form = SurveyEngine.LeadsForms.get_leads_form!(params["lead_form_id"])

    {:ok, external_survey} = get_external_form(lead_form, socket.assigns.site_config.id)

    socket
    |> assign(:page_title, "Listing Survey mapper")
    |> assign_survey_mapper(params)
    |> assign(index_params: params)
    |> assign(:external_survey, external_survey)
    |> assign(
      :fields,
      SurveyEngine.SurveyMappers.get_fields_of_schema(Affiliate) |> format_data() |> IO.inspect()
    )
    |> assign(:lead_form, lead_form)
  end

  defp current_index_path(index_params) do
    ~p"/survey_mapper?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/survey_mapper?#{query_params}")}
  end

  def handle_event("add", _, socket) do
    {:noreply,
     socket
     |> assign(
       :survey_mapper,
       (socket.assigns.survey_mapper ++ [%SurveyMapper{}]) |> IO.inspect()
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    survey_mapper = SurveyMappers.get_survey_mapper!(id)
    {:ok, _} = SurveyMappers.delete_survey_mapper(survey_mapper)

    socket =
      socket
      |> assign_survey_mapper(socket.assigns.index_params)
      |> put_flash(:info, "Survey mapper deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_survey_mapper(socket, params) do
    starting_query = SurveyMapper
    {survey_mapper, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, survey_mapper: survey_mapper, meta: meta)
  end

  def get_external_form(leads_form, site_config_id) do
    SurveyEngine.Responses.ResponseProviderBuilder.build_response_provider(
      leads_form.provider,
      site_config_id,
      %{id: leads_form.external_id}
    )
    |> SurveyEngine.Responses.ExternalSurveyEngine.get_survey()
  end

  defp format_data(list) do
    list
    |> Enum.reduce([], fn %{field: field, deps: deps}, acc ->
      [field | acc]
    end)
  end
end
