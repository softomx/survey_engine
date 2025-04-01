defmodule SurveyEngineWeb.AdminCompanyLive.Index do
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
    {:ok, assign(socket, :index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listado de empresas")
    |> assign(:company, nil)
    |> assign_companies(params)
    |> assign(:index_params, params)
  end

  defp assign_companies(socket, params) do
    starting_query = Company
    {companies, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, companies: companies, meta: meta)
  end
end
