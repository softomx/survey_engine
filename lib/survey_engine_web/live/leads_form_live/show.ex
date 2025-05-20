defmodule SurveyEngineWeb.LeadsFormLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.LeadsForms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id, "form_group_id" => form_group_id}) do
    lead_form = LeadsForms.get_leads_form!(id)

    {:ok, external_form} =
      get_external_form(lead_form, socket.assigns.site_config.id)

    questions = external_form.questions |> order_questions()

    socket
    |> assign(:page_title, "Detalle del formulario")
    |> assign(:leads_form, lead_form)
    |> assign(:form_group_id, form_group_id)
    |> assign(:external_form, external_form)
    |> assign(:questions, questions)
  end

  defp order_questions(questions) do
    questions
    |> Enum.sort_by(fn {_, question_params} -> question_params.index end)
  end

  def get_external_form(leads_form, site_config_id) do
    SurveyEngine.Responses.ResponseProviderBuilder.build_response_provider(
      leads_form.provider,
      site_config_id,
      %{id: leads_form.external_id}
    )
    |> SurveyEngine.Responses.ExternalSurveyEngine.get_survey()
  end
end
