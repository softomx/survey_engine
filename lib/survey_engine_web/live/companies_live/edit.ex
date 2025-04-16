defmodule SurveyEngineWeb.CompaniesLive.Edit do
  use SurveyEngineWeb, :live_view
  alias SurveyEngine.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Empresa")
    |> assign(:company, Companies.get_company!(id))
  end
end
