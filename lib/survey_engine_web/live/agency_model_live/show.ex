defmodule SurveyEngineWeb.AgencyModelLive.Show do
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
     |> assign(:agency_model, Catalogs.get_agency_model!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/catalogs/agency_models/#{socket.assigns.agency_model}")}
  end

  defp page_title(:show), do: "Show Agency model"
  defp page_title(:edit), do: "Edit Agency model"
end
