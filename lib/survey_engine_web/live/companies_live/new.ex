defmodule SurveyEngineWeb.CompaniesLive.New do
  alias SurveyEngine.Companies.Company
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

  defp apply_action(socket, :new, _params) do
    if socket.assigns.current_user.company_id do
      socket
      |> push_navigate(to: ~p"/company")
    else
      socket
      |> assign(:page_title, gettext("preregister.title"))
      |> assign(:company, %Company{country: "MX"})
    end
  end
end
