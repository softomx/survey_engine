defmodule SurveyEngineWeb.AgencyTypeLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Catalogs
  alias SurveyEngine.Catalogs.AgencyType
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
    |> assign(:page_title, "Edit Agency type")
    |> assign(:agency_type, Catalogs.get_agency_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Agency type")
    |> assign(:agency_type, %AgencyType{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Agency types")
    |> assign(:agency_type, nil)
    |> assign_agency_types(params)
    |> assign(:index_params, params)
  end

  @impl true
  def handle_info({SurveyEngineWeb.AgencyTypeLive.FormComponent, {:saved, agency_type}}, socket) do
    {:noreply, stream_insert(socket, :agency_types, agency_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    agency_type = Catalogs.get_agency_type!(id)
    {:ok, _} = Catalogs.delete_agency_type(agency_type)

    {:noreply, stream_delete(socket, :agency_types, agency_type)}
  end

  defp assign_agency_types(socket, params) do
    starting_query = Catalogs.AgencyType
    {agency_types, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, agency_types: agency_types, meta: meta)
  end
end
