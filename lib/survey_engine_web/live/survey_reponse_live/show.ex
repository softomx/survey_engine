defmodule SurveyEngineWeb.SurveyReponseLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Responses

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/survey_answers/#{socket.assigns.survey_response}")}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    {:ok, survey_response} = Responses.get_survey_response_with_preloads(id, [[response_items: :editor_user]])

     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:survey_response, survey_response)
  end

  defp apply_action(socket, :edit_response_item, %{"id" => id, "item_id" => item_id}) do
    {:ok, survey_response} = Responses.get_survey_response_with_preloads(id, [[response_items: :editor_user],  :lead_form])
    response_item = Enum.find(survey_response.response_items, fn item -> "#{item.id}" == item_id end)
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:survey_response, survey_response)
    |> assign(:survey_response_item, response_item)
    |> assign(:external_form, get_external_form(survey_response, socket.assigns.site_config.id))
 end

  defp page_title(:show), do: "Show Survey response"
  defp page_title(:edit_response_item), do: "Edit Survey response"

  def get_external_form(survey_response, site_config_id) do
    SurveyEngine.Responses.ResponseProviderBuilder.build_response_provider(
      survey_response.lead_form.provider,
      site_config_id,
      %{id: survey_response.lead_form.external_id}
    )
    |> SurveyEngine.Responses.ExternalSurveyEngine.get_survey()
    |> case do
      {:ok, form} -> form
      {:error, _error} -> %{questios: %{}}
    end
  end

end
