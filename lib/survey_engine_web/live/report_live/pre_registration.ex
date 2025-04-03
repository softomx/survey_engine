defmodule SurveyEngineWeb.ReportLive.PreRegistration do
  use SurveyEngineWeb, :live_view
  alias SurveyEngine.{Companies, BusinessModels}
  alias SurveyEngine.Filters.PreRegistrationFilter
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
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
    socket
    |> init_table(%{})
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
      %{title: "Idioma", type: "text", data: "language"},
      %{title: "Agency_name", type: "text", data: "agency_name"},
      %{title: "Legal_name", type: "text", data: "legal_name"},
      %{title: "Country", type: "text", data: "country"},
      %{title: "Town", type: "text", data: "town"},
      %{title: "city", type: "text", data: "city"},
      %{title: "agency_type", type: "text", data: "agency_type"},
      %{title: "business_model", type: "text", data: "business_model"},
      %{title: "billing_currency", type: "text", data: "billing_currency"},
      %{title: "status", type: "text", data: "status"}
    ]
  end

  defp get_rows(params) do
    SurveyEngine.Companies.list_companies(%{filter: params})
    |> SurveyEngine.Companies.list_companies_with_preloads()
    |> Stream.map(fn company ->
      business_model = if company.business_model, do: company.business_model.name, else: "-"
      %{
        language: company.language,
        agency_name: company.agency_name,
        legal_name: company.legal_name,
        country: company.country,
        town: company.town,
        city: company.city,
        agency_type: company.agency_type,
        business_model: business_model,
        billing_currency: company.billing_currency,
        status: company.status
      }
    end)
    |> Enum.to_list()
  end
end
