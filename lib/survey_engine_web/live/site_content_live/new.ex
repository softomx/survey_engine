defmodule SurveyEngineWeb.SiteContentLive.New do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations.Translation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
         socket,
         :new,
         %{"behaviour" => behaviour} = _params
       ) do
    socket
    |> assign(:page_title, "Nueva traduccion")
    |> assign(:translation, %Translation{})
    |> assign(:resource_id, socket.assigns.site_config.id)
    |> assign(:type, "site_configurations")
    |> assign(:behaviour, behaviour)
  end
end
