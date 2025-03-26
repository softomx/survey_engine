defmodule SurveyEngineWeb.AgencyTypeLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Catalogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:agency_type, Catalogs.get_agency_type!(id))}
  end

  defp page_title(:show), do: "Show Agency type"
  defp page_title(:edit), do: "Edit Agency type"
end
