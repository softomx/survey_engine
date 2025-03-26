defmodule SurveyEngineWeb.CompanyLive.New do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Companies
  alias SurveyEngine.Companies.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    if company_id = socket.assigns.current_user.company_id do
      company = Companies.get_company(company_id)

      socket
      |> push_patch(to: ~p"/company")
    else
      socket
      |> assign(:page_title, "New Form registration")
      |> assign(:company, %Company{})
    end
  end
end
