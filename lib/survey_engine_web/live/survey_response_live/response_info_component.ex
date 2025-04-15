defmodule SurveyEngineWeb.SurveyResponseLive.ResponseInfoComponent do
  use SurveyEngineWeb, :live_component
  alias SurveyEngine.Responses
  alias SurveyEngine.TransaleteHelper

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <div
        :if={@survey_response.state == "finished" and @survey_response.review_state == "pending"}
        class="flex justify-end gap-2"
      >
      </div>
      <div class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
        <div class="sm:col-span-1">
          <div class="text-sm font-bold text-gray-500 dark:text-gray-400">
            {gettext("survey_response.date")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {SurveyEngine.format_date(@survey_response.date)}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-bold text-gray-500 dark:text-gray-400">
            {gettext("survey_response.state")}
          </div>
          <div class="flex gap-2 mt-1 text-sm text-gray-900 dark:text-gray-100">
            <.icon
              :if={@survey_response.state == "finished"}
              name="hero-check-circle"
              class="text-primary-700 dark:text-primary-300"
            />
            <.icon
              :if={@survey_response.state != "finished"}
              name="hero-arrow-path-rounded-square"
              class="text-primary-700 dark:text-primary-300"
            />
            <.badge
              color="primary"
              label={TransaleteHelper.survey_response_state(@survey_response.state)}
            />
          </div>
        </div>
      </div>

      <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
        <.card_survey_response survey_response={@survey_response} />
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end
end
