defmodule SurveyEngineWeb.ReportLive.PreRegistration do
  use SurveyEngineWeb, :live_view
  alias SurveyEngine.{Companies, BusinessModels}
  alias SurveyEngine.Filters.PreRegistrationFilter
  alias SurveyEngine.TransaleteHelper
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:response_states, TransaleteHelper.list_survey_response_states())
      |> assign(:list_languages, TransaleteHelper.list_languages())
      |> assign(:agency_types, Companies.get_agency_types())
      |> assign(:countries, Companies.get_countries())
      |> assign(:towns, Companies.get_towns())
      |> assign(:business_models, BusinessModels.list_business_models() |> Enum.map(fn bm -> {bm.name, bm.id} end))
     |> assign_new(:form, fn ->
      to_form(PreRegistrationFilter.changeset(%PreRegistrationFilter{}, %{}))
    end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :pre_registration, %{"pre_registration_filter" => params}) do
    changeset = PreRegistrationFilter.changeset(%PreRegistrationFilter{}, params)
    params =  changeset |> Ecto.Changeset.apply_changes()
    socket
    |> assign(:form, to_form(changeset))
    |> init_table(Map.from_struct(params))
  end

  defp apply_action(socket, :pre_registration, _params) do
    default_params = %{register_dates: %{start_date: Timex.today(), end_date: Timex.today()}}
    changeset = PreRegistrationFilter.changeset(%PreRegistrationFilter{}, default_params)
    params = changeset |> Ecto.Changeset.apply_changes()
    socket
    |> assign(:form, to_form(changeset))
    |> init_table(Map.from_struct(params))
  end

  defp init_table(socket, params) do
    socket
    |> push_event("initHandSomeTable", %{
      cols: get_cols(),
      rows: get_rows(params)
    })
  end

  @impl true
  def handle_event("export", _, socket) do
      date = Timex.today("America/Cancun")
      filename = "ReportePreRegistro_#{date}"
      {:noreply,
       socket
       |> push_event("export", %{filename: filename})}
  end

  def handle_event("filter", params, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/reports/pre_registration?#{params}")}
  end

  defp get_cols() do
    [
      %{title: gettext("report.register_date"), type: "text", data: "inserted_at"},
      %{title: gettext("language"), type: "text", data: "language"},
      %{title: gettext("company name"), type: "text", data: "legal_name"},
      %{title: gettext("country"), type: "text", data: "country"},
      %{title: gettext("town"), type: "text", data: "town"},
      %{title: gettext("city"), type: "text", data: "city"},
      %{title: gettext("agency type"), type: "text", data: "agency_type"},
      %{title: gettext("business model"), type: "text", data: "business_model"},
      %{title: gettext("billing currency"), type: "text", data: "billing_currency"},
      %{title: "status", type: "text", data: "status"}
    ]
  end

  defp get_rows(params) do
    SurveyEngine.Companies.list_companies(%{filter: params})
    |> SurveyEngine.Companies.list_companies_with_preloads()
    |> Stream.map(fn company ->
      business_model = if company.business_model, do: company.business_model.name, else: "-"
      %{
        inserted_at: SurveyEngine.to_timezone(company.inserted_at),
        language: TransaleteHelper.language(company.language),
        legal_name: company.legal_name,
        country: company.country,
        town: company.town,
        city: company.city,
        agency_type: company.agency_type,
        business_model: business_model,
        billing_currency: String.upcase(company.billing_currency),
        status: company.status |> TransaleteHelper.survey_response_state()
      }
    end)
    |> Enum.to_list()
  end
end
