defmodule SurveyEngineWeb.ReportLive.SurveyResponse do
  use SurveyEngineWeb, :live_view
  alias SurveyEngine.Responses
  alias SurveyEngine.{Companies, BusinessModels, LeadsForms}
  alias SurveyEngine.Filters.SurveyResponseFilter
  alias SurveyEngine.TransaleteHelper
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       :form_groups,
       LeadsForms.list_form_groups() |> Enum.map(fn fg -> {fg.name, fg.id} end)
     )
     |> assign(:response_states, TransaleteHelper.list_survey_response_states())
     |> assign(:agency_types, Companies.get_agency_types())
     |> assign(:countries, Companies.get_countries())
     |> assign(
       :business_models,
       BusinessModels.list_business_models() |> Enum.map(fn bm -> {bm.name, bm.id} end)
     )
     |> assign_new(:form, fn ->
       to_form(SurveyResponseFilter.changeset(%SurveyResponseFilter{}, %{}))
     end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :survey_response, %{"survey_response_filter" => params}) do
    changeset = SurveyResponseFilter.changeset(%SurveyResponseFilter{}, params)

    socket
    |> assign(:form, to_form(changeset))
    |> init_table(changeset)
  end

  defp apply_action(socket, :survey_response, _params) do
    default_params = %{company_filter: %{register_dates: %{start_date: Timex.today(), end_date: Timex.today()}}}
    changeset = SurveyResponseFilter.changeset(%SurveyResponseFilter{}, default_params)

    socket
    |> assign(:form, to_form(changeset))
    |> init_table(changeset)
  end

  defp init_table(socket, changeset) do
    params = changeset |> Ecto.Changeset.apply_changes() |> SurveyEngine.santize_map()

    socket
    |> push_event("initHandSomeTable", %{
      cols: get_cols(),
      rows: get_rows(params)
    })
  end

  @impl true
  def handle_event("export", _, socket) do
    date = Timex.today("America/Cancun")
    filename = "ReporteGeneral_#{date}"

    {:noreply,
     socket
     |> push_event("export", %{filename: filename})}
  end

  def handle_event("filter", params, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/reports/response?#{params}")}
  end

  defp get_cols() do
    [
      %{title: gettext("report.register_date"), type: "text", data: "inserted_at"},
      %{title: gettext("company name"), type: "text", data: "legal_name"},
      %{title: gettext("agency type"), type: "text", data: "agency_type"},
      %{title: gettext("business model"), type: "text", data: "business_model"},
      %{title: gettext("country"), type: "text", data: "country"},
      %{title: gettext("user"), type: "text", data: "user_email"},
      %{title: gettext("state"), type: "text", data: "state"},
      %{title: gettext("report.form_groups"), type: "text", data: "form"},
      %{title: gettext("question"), type: "text", data: "question"},
      %{title: gettext("answer"), type: "text", data: "answer"}
    ]
  end

  defp get_rows(params) do
    Responses.list_survey_resposes(%{filter: params})
    |> Responses.survey_resposes_with_preloads([:form_group, user: [company: [:business_model]]])
    |> Stream.map(fn response ->
      business_model =
        if response.user.company.business_model,
          do: response.user.company.business_model.name,
          else: "-"

      response.data["response"]
      |> Enum.map(fn d ->
        %{
          inserted_at: SurveyEngine.to_timezone(response.user.company.inserted_at),
          legal_name: response.user.company.legal_name,
          agency_type: response.user.company.agency_type,
          business_model: business_model,
          country: response.user.company.country,
          user_email: response.user.email,
          state: response.state |> TransaleteHelper.survey_response_state(),
          form: response.form_group.name,
          question: d["question"],
          answer:
            if d["type"] == "fileUpload" do
              "Documento.PDF"
            else
              d["answer"]
            end
        }
      end)
    end)
    |> Enum.to_list()
    |> List.flatten()
  end
end
