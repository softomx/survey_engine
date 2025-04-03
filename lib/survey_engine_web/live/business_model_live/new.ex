defmodule SurveyEngineWeb.BusinessModelForm.New do
  alias SurveyEngine.LeadsForms
  alias SurveyEngine.Responses
  alias SurveyEngine.Companies
  alias SurveyEngine.Responses.ResponseProviderBuilder
  use SurveyEngineWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, %{"id" => id}) do
    if company = socket.assigns.current_user.company_id do
      with {:ok, company} <-
             Companies.get_company(company),
           {:ok, form_group} <- {:ok, LeadsForms.get_form_group!(id)},
           {:ok, lead_from} <-
             {:ok,
              LeadsForms.get_lead_form_by_language_or_default(
                form_group.id,
                socket.assigns.locale
              )} do
        socket
        |> assign(:page_title, nil)
        |> assign(:register_form, company)
        |> assign(:form_group, form_group)
        |> assign_preious_response(lead_from, socket.assigns.current_user, company)
      end
    else
      socket
    end
  end

  defp assign_preious_response(socket, lead_form, user, company) do
    previous_response = Responses.get_previous_response(lead_form.form_group_id, user.id)

    url =
      ResponseProviderBuilder.build_response_provider(
        lead_form.provider,
        socket.assigns.site_config,
        %{
          response: previous_response,
          current_user: user,
          company: company,
          form: lead_form,
          lang: socket.assigns.locale
        }
      )
      |> SurveyEngine.Responses.ResponseEngine.build_url_embed_survey()

    assign(socket, previous_response: previous_response)
    |> assign(url: url)
  end
end
