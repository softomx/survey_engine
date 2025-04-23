defmodule SurveyEngineWeb.SiteContentLive.Edit do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{
         "id" => id,
         "behaviour" => behaviour
       }) do
    socket
    |> assign(:page_title, "Edit Translation")
    |> assign(:translation, Translations.get_translation!(id))
    |> assign(:behaviour, behaviour)
    |> assign(:resource_id, socket.assigns.site_config.id)
    |> assign(:type, "site_configurations")
  end
end
