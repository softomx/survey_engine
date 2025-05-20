defmodule SurveyEngineWeb.AdminCompanyLive.Index do
  alias SurveyEngine.BusinessModels
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Companies
  alias SurveyEngine.Companies.Company
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :status, :legal_name, :agency_name],
    filterable: [:id, :inserted_at, :status, :legal_name, :agency_name]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :index_params, nil)
     |> assign(:meta, %Flop.Meta{})
     |> assign(:response_states, SurveyEngine.TransaleteHelper.list_survey_response_states())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    businnes_models = BusinessModels.list_business_models()

    socket
    |> assign(:page_title, "Listado de empresas")
    |> assign(:company, nil)
    |> assign(:businnes_models, businnes_models)
    |> assign_companies(params)
    |> assign(:index_params, params)
  end

  @impl true
  def handle_event("submit-filter", %{"filter" => params}, %{assigns: _assigns} = socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/companies?#{params}")}
  end

  @impl true
  def handle_event("reset-filter", _, %{assigns: _assigns} = socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/companies")}
  end

  defp assign_companies(socket, params) do
    starting_query = build_start_query(socket.assigns.current_user)

    {companies, meta} = DataTable.search(starting_query, params, @data_table_opts)
    companies = companies |> Companies.list_companies_with_preloads()
    assign(socket, companies: companies, meta: meta)
  end

  defp build_start_query(current_user) do
    roles = current_user.roles |> Enum.map(& &1.slug)

    cond do
      "root" in roles ->
        Company

      true ->
        Companies.companies_filter(
          Company,
          %{ejecutive_id: current_user.id}
        )
    end
  end
end
