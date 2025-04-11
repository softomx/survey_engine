defmodule SurveyEngineWeb.SurveyResponseLive.Validate do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.NotificationManager
  alias SurveyEngine.Responses
  alias SurveyEngine.Responses.SurveyResponse

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, index_params: nil)
     |> assign_new(:form, fn ->
       to_form(SurveyResponse.changeset(%SurveyResponse{}, %{}))
     end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :validate, %{"id" => id}) do
    socket
    |> assign(:page_title, "Validar")
    |> assign(:survey_response, Responses.get_survey_response!(id))
  end

  @impl true
  def handle_event("validate", %{"survey_response" => response_params}, socket) do
    changeset = Responses.change_survey_response(socket.assigns.survey_response, response_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"survey_response" => response_params}, socket) do
    with {:ok, survey_response} <-
           Responses.update_survey_response(socket.assigns.survey_response, response_params),
          {:ok, _notification} <- send_notification(survey_response, socket.assigns.site_config) do
      {:noreply,
       socket
       |> put_flash(:info, "Respuesta validad, se notificara al correo")
       |> push_navigate(to: ~p"/survey_responses/#{survey_response}")}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      error ->
        IO.inspect(error)
        {:noreply, socket}
    end
  end

  defp send_notification(survey_response, site_config) do
    case survey_response.review_state do
     "rejected" ->
        NotificationManager.notify_review_survey(survey_response, site_config)
      "approved" ->
        NotificationManager.notify_review_survey(survey_response, site_config)
      _ ->
        {:ok, survey_response}
    end
  end
end
