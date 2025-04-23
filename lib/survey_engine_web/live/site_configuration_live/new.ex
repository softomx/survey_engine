defmodule SurveyEngineWeb.SiteConfigurationLive.New do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SiteConfigurations.SiteConfiguration

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.live_component
      module={SurveyEngineWeb.SiteConfigurationLive.FormComponent}
      id={@site_configuration.id || :new}
      title={@page_title}
      action={@live_action}
      site_configuration={@site_configuration}
      patch={~p"/admin/site_configurations"}
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nuevo sitio")
    |> assign(:site_configuration, %SiteConfiguration{})
  end
end
