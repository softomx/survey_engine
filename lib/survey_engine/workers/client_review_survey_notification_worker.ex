defmodule SurveyEngine.Workers.ClientReviewSurveyNotificationWorker do
  alias SurveyEngine.Responses
  alias SurveyEngine.Accounts.{UserNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications

  def perform(survey_resonse_id, site_config_id) do
    with {:ok, survey_response} <-
           Responses.get_survey_response_with_preloads(survey_resonse_id, user: :company),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, notification_config} <- get_notification_review_state(survey_response) do
      notify_client(
        survey_response.user,
        survey_response.user.company,
        survey_response,
        site_config,
        notification_config
      )
    end
  end

  defp notify_client(user, company, survey_response, site_config, notification_config) do
    with {:ok, content} <-
           Notifications.get_content_by_language(notification_config.contents, company.language),
         {:ok, subject} <-
           Notifications.get_content_by_language(notification_config.subjects, company.language) do
      deliver_by_review_state(user, subject, survey_response, content, site_config)
    end
  end

  defp deliver_by_review_state(
         user,
         subject,
         %{review_state: "rejected"} = survey_response,
         content,
         site_config
       ) do
    UserNotifier.deliver_rejected_survey(
      user,
      subject.description,
      %{
        survey_response: survey_response,
        content: content,
        site_config: site_config,
        company: survey_response.user.company,
        locale: survey_response.user.company.language
      },
      site_config.id
    )
  end

  defp deliver_by_review_state(
         user,
         subject,
         %{review_state: "approved"} = survey_response,
         content,
         site_config
       ) do
    UserNotifier.deliver_approved_survey(
      user,
      subject.description,
      %{
        survey_response: survey_response,
        content: content,
        site_config: site_config,
        company: survey_response.user.company,
        locale: survey_response.user.company.language
      },
      site_config.id
    )
  end

  defp get_notification_review_state(survey_response) do
    case survey_response.review_state do
      "rejected" ->
        Notifications.get_notification_by_action("info_rejected")

      "approved" ->
        Notifications.get_notification_by_action("approved")

      _ ->
        {:error, "not implemented #{survey_response.review_state}"}
    end
  end
end
