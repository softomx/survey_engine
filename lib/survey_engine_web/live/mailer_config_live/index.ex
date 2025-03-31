defmodule SurveyEngineWeb.MailerConfigLive.Index do
  alias SurveyEngine.Mailer.MailerManager
  alias SurveyEngine.Mailer.MailerConfiguration
  use SurveyEngineWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar configuracion de correo")
    |> assign(:site_config_id, socket.assigns.site_config.id)
    |> assign(:mailer_config, MailerManager.get_mailer_config!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nueva configuracion de correo")
    |> assign(:site_config_id, socket.assigns.site_config.id)
    |> assign(:mailer_config, %MailerConfiguration{
      site_configuration_id: socket.assigns.site_config.id
    })
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Configuracion de correos")
    |> assign(:mailer_config, nil)
    |> assign(:index_params, params)
    |> assign(
      :mailer_config,
      MailerManager.get_mailer_configuration_by_site!(socket.assigns.site_config.id)
    )
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     push_patch(socket,
       to: current_index_path()
     )}
  end

  defp current_index_path() do
    ~p"/admin/mailer_config"
  end
end
