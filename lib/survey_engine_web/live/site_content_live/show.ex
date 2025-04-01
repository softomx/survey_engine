defmodule SurveyEngineWeb.SiteContentLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"id" => id, "behaviour" => behaviour},
        _,
        socket
      ) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:behaviour, behaviour)
     |> assign(:translation, Translations.get_translation!(id))}
  end

  defp page_title(:show), do: "Show Translation"
  defp page_title(:edit), do: "Edit Translation"
end
