defmodule SurveyEngine.Workers.AdminReviewSurveyNotificationWorker do
  alias SurveyEngine.Accounts
  alias SurveyEngine.Responses
  alias SurveyEngine.Accounts.{AdminNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications

  def perform(survey_resonse_id, site_config_id) do
    with {:ok, survey_response} <-
           Responses.get_survey_response_with_preloads(survey_resonse_id, user: :company),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, notification_config} <- get_notification_review_state(survey_response),
         {:ok, content} <-
           Notifications.get_content_by_language(
             notification_config.contents,
             survey_response.user.company.language
           ),
         {:ok, emails} <- {:ok, get_emails(notification_config, survey_response)} do
      deliver_by_review_state(emails, content, survey_response, site_config)
    end
  end

  defp get_emails(notification_config, survey_response) do
    ccp =
      notification_config.to
      |> Enum.map(fn e -> e.email end)

    if survey_response.user.company.ejecutive_id do
      user = Accounts.get_user!(survey_response.user.company.ejecutive_id)
      [user.email | ccp]
    else
      ccp
    end
  end

  defp deliver_by_review_state(
         emails,
         content,
         %{review_state: "rejected"} = survey_response,
         site_config
       ) do
    AdminNotifier.deliver_rejected_survey(
      emails,
      "Información Rechazada",
      %{
        survey_response: survey_response,
        site_config: site_config,
        locale: survey_response.user.company.language,
        content: content,
        company: survey_response.user.company,
        user: survey_response.user
      },
      site_config.id
    )
  end

  defp deliver_by_review_state(
         emails,
         content,
         %{review_state: "approved"} = survey_response,
         site_config
       ) do
    AdminNotifier.deliver_approved_survey(
      emails,
      "Información aprovada",
      %{
        survey_response: survey_response,
        site_config: site_config,
        locale: survey_response.user.company.language,
        content: content,
        company: survey_response.user.company,
        user: survey_response.user
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
