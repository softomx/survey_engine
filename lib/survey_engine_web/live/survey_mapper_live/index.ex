defmodule SurveyEngineWeb.SurveyMapperLive.Index do
  alias SurveyEngine.LeadsForms
  alias SurveyEngine.AffiliateEngine.Affiliate
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SurveyMappers
  alias SurveyEngine.SurveyMappers.SurveyMapper

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
    lead_form = LeadsForms.get_leads_form!(params["lead_form_id"])

    with {:ok, external_survey} <- get_external_form(lead_form, socket.assigns.site_config.id),
         {:ok, questions} <- {:ok, external_survey |> remove_invalid_questions()} do
      socket
      |> assign(
        :page_title,
        "Listado de mapeos para el formulario #{lead_form.form_group.name} #{lead_form.language |> String.upcase()}"
      )
      |> assign(index_params: params)
      |> assign(:questions, questions)
      |> assign(
        :fields,
        SurveyEngine.SurveyMappers.get_fields_of_schema(Affiliate)
        |> format_data()
      )
      |> assign(:lead_form, lead_form)
      |> assign_survey_mapper(params)
    end
  end

  def handle_info({:delete_mapper, index}, socket) do
    survey_mapper = List.delete_at(socket.assigns.survey_mapper, index)

    socket =
      socket
      |> assign(:survey_mapper, survey_mapper)

    {:noreply, socket}
  end

  def handle_info({:save_mapper, {index, mapper_updated}}, socket) do
    survey_mapper =
      List.update_at(socket.assigns.survey_mapper, index, fn _ -> mapper_updated end)

    socket =
      socket
      |> assign(:survey_mapper, survey_mapper)

    {:noreply, socket}
  end

  def handle_event("add", _, socket) do
    {:noreply,
     socket
     |> assign(
       :survey_mapper,
       socket.assigns.survey_mapper ++ [%SurveyMapper{}]
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

  defp assign_survey_mapper(socket, _params) do
    survey_mapper =
      SurveyMappers.list_survey_mappers(%{filter: %{survey_id: socket.assigns.lead_form.id}})

    assign(socket, survey_mapper: survey_mapper)
  end

  def get_external_form(leads_form, site_config_id) do
    SurveyEngine.Responses.ResponseProviderBuilder.build_response_provider(
      leads_form.provider,
      site_config_id,
      %{id: leads_form.external_id}
    )
    |> SurveyEngine.Responses.ExternalSurveyEngine.get_survey()
  end

  defp format_data(list, parent \\ nil) do
    list
    |> Enum.reduce([], fn %{field: field, deps: deps}, acc ->
      acc = acc ++ format_data(deps, field)

      field =
        if parent do
          {"#{parent}->#{field}", "#{parent}/#{field}"}
        else
          {field, field}
        end

      [field | acc]
    end)
  end

  defp remove_invalid_questions(external_survey) do
    external_survey.questions
    |> Enum.filter(fn {_id, question} ->
      question.type != "fileUpload"
    end)
  end
end
