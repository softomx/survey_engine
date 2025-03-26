defmodule SurveyEngineWeb.SiteConfigurationLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.SiteConfigurations.SiteConfiguration
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
    |> assign(:page_title, "Edit Site configuration")
    |> assign(:site_configuration, SiteConfigurations.get_site_configuration!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site configuration")
    |> assign(:site_configuration, %SiteConfiguration{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Site configurations")
    |> assign(:site_configuration, nil)
    |> assign(:index_params, params)
    |> assign_site_configurations(params)
  end

  @impl true
  def handle_info(
        {SurveyEngineWeb.SiteConfigurationLive.FormComponent, {:saved, site_configuration}},
        socket
      ) do
    {:noreply, stream_insert(socket, :site_configurations, site_configuration)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site_configuration = SiteConfigurations.get_site_configuration!(id)
    {:ok, _} = SiteConfigurations.delete_site_configuration(site_configuration)

    {:noreply, stream_delete(socket, :site_configurations, site_configuration)}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     push_patch(socket,
       to: current_index_path(socket.assigns.index_params)
     )}
  end

  defp assign_site_configurations(socket, params) do
    starting_query = SiteConfiguration
    {site_configurations, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, site_configurations: site_configurations, meta: meta)
  end

  defp current_index_path(index_params) do
    ~p"/admin/site_configurations?#{index_params || %{}}"
  end
end
