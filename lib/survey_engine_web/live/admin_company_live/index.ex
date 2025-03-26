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
    sortable: [:id, :inserted_at],
    filterable: [:id, :inserted_at]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar espresa")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Agency type")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Agency types")
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
