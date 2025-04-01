defmodule SurveyEngineWeb.BusinessConfigLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.BusinessModels

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "business_model_id" => business_model_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:business_config, BusinessModels.get_business_config!(id))
     |> assign(:business_model_id, business_model_id)}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     push_patch(socket,
       to:
         ~p"/admin/catalogs/business_models/#{socket.assigns.business_model_id}/business_configs/#{socket.assigns.business_config}"
     )}
  end

  defp page_title(:show), do: "Ver asignacion de formulario"
  defp page_title(:edit), do: "Editar asignacion de formulario"
end
