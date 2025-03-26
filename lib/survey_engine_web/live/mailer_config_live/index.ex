defmodule SurveyEngineWeb.MailerConfigLive.Index do
  alias SurveyEngine.Mailer.MailerManager
  alias SurveyEngine.Mailer.MailerConfiguration
  use SurveyEngineWeb, :live_view

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
    |> assign(:site_config_id, socket.assigns.site_config.id)
    |> assign(:mailer_config, MailerManager.get_mailer_config!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site configuration")
    |> assign(:site_config_id, socket.assigns.site_config.id)
    |> assign(:mailer_config, %MailerConfiguration{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Site configurations")
    |> assign(:mailer_config, nil)
    |> assign(:index_params, params)
    |> assign(:site_config_id, socket.assigns.site_config.id)
    |> assign_mailer_configs(params)
  end

  @impl true
  def handle_info(
        {SurveyEngineWeb.MailerConfigLive.FormComponent, {:saved, mailer_config}},
        socket
      ) do
    {:noreply, stream_insert(socket, :mailer_configs, mailer_config)}
  end

  defp assign_mailer_configs(socket, params) do
    starting_query = MailerConfiguration
    {mailer_configs, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, mailer_configs: mailer_configs, meta: meta)
  end
end
