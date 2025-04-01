defmodule SurveyEngineWeb.CompanyLive.Index do
  alias SurveyEngine.Responses
  alias SurveyEngine.BusinessModels
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Companies
  alias SurveyEngine.TransaleteHelper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:company, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    if company_id = socket.assigns.current_user.company_id do
      company = Companies.get_company!(company_id)

      socket
      |> assign(:page_title, "Empresa")
      |> assign(:company, company)
      |> assign_business_configs(company)
      |> assign_user_responses(socket.assigns.current_user)
    else
      socket
    end
  end

  defp assign_business_configs(socket, %{business_model_id: nil}),
    do: socket |> assign(:business_configs, [])

  defp assign_business_configs(socket, company) do
    business_configs =
      BusinessModels.list_business_configs(%{
        filter: %{business_model_id: company.business_model_id}
      })
      |> SurveyEngine.Repo.preload([:form_group])

    socket |> assign(:business_configs, business_configs)
  end

  defp assign_user_responses(socket, current_user) do
    responses =
      Responses.list_survey_resposes(%{filter: %{user_id: current_user.id}})

    business_configs =
      socket.assigns.business_configs
      |> Enum.map(fn bc ->
        response =
          responses
          |> Enum.find(fn r ->
            r.form_group_id == bc.form_group_id
          end)

        bc
        |> Map.put(:response, response)
      end)

    socket
    |> assign(:business_configs, business_configs)
    |> assign(:response, responses)
  end
end
