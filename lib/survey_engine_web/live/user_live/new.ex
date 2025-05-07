defmodule SurveyEngineWeb.UserLive.New do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts.User

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _) do
    socket
    |> assign(:page_title, "Nuevo usuario")
    |> assign(:user, %User{roles: []})
  end
end
