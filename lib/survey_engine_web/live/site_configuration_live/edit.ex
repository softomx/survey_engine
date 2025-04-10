defmodule SurveyEngineWeb.SiteConfigurationLive.Edit do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.SiteConfigurations.SiteConfiguration
  alias PetalFramework.Components.DataTable
  @impl true
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

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar sitio")
    |> assign(:site_configuration, SiteConfigurations.get_site_configuration!(id))
  end
end
