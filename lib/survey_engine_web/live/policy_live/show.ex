defmodule SurveyEngineWeb.PolicyLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        _params,
        _,
        %{assigns: assigns} = socket
      ) do
    with {:ok, policies} <-
           Translations.get_transalation_by_language_or_default(
             assigns.site_config.id,
             "site_configurations",
             "policies",
             assigns.locale
           ) do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(
         :policies,
         policies
       )}
    end
  end

  defp page_title(:show), do: gettext("Politicas")
  defp page_title(:edit), do: gettext("Edit Translation")
end
