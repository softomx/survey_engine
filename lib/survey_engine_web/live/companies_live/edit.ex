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

  defp apply_action(socket, :edit, _params) do
    if company_id = socket.assigns.current_user.company_id do
      company = Companies.get_company!(company_id)

      socket
      |> assign(:page_title, gettext("preregister.title"))
      |> assign(:company, company)
    else
      socket
      |> put_flash(:error, gettext("preregister.error.edit"))
      |> push_navigate(to: ~p"/company")
    end
  end
end
