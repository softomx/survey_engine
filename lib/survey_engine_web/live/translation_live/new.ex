defmodule SurveyEngineWeb.TranslationLive.New do
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
         %{"type" => type, "resource_id" => resource_id, "behaviour" => behaviour} = _params
       ) do
    socket
    |> assign(:page_title, "New Translation")
    |> assign(:translation, %Translation{})
    |> assign(:resource_id, resource_id)
    |> assign(:type, type)
    |> assign(:behaviour, behaviour)
  end
end
