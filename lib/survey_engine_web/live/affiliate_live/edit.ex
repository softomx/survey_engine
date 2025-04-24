defmodule SurveyEngineWeb.AffiliateLive.Edit do
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.AffiliateEngine

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"company_id" => company_id, "id" => id}) do
    socket
    |> assign(:page_title, "Editar Afiliado")
    |> assign(:affiliate, AffiliateEngine.get_affiliate!(id))
    |> assign(
      :currencies,
      Catalogs.list_currencies() |> Enum.map(&{&1.name, String.downcase(&1.name)})
    )
    |> assign(:company_id, company_id)
  end
end
