defmodule SurveyEngineWeb.AffiliateLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.AffiliateEngine

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:affiliate, AffiliateEngine.get_affiliate!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/affiliates/#{socket.assigns.affiliate}")}
  end

  defp page_title(:show), do: "Show Affiliate"
  defp page_title(:edit), do: "Edit Affiliate"
end
