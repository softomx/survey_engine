defmodule SurveyEngine.Workers.AdminSurveyUpdatedNotificationWorker do
  alias SurveyEngine.Responses
  alias SurveyEngine.Accounts.{AdminNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(response_id, company_id, site_config_id) do
    with {:ok, response} <- {:ok, Responses.get_survey_response!(response_id)},
         {:ok, user} <- Accounts.get_user_by_company(company_id),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(company_id),
         {:ok, notification_config} <-
           Notifications.get_notification_by_action("validating_info"),
         {:ok, emails} <- {:ok, get_emails(notification_config)} do
      AdminNotifier.deliver_survey_updated(
        emails,
        "Asignacion de modelo de negocio",
        %{company: company, user: user, site_config: site_config, response: response},
        site_config.id
      )
    end
  end

  defp get_emails(notification_config) do
    (notification_config.to ++ [%{email: "joss1091@gmail.com"}])
    |> Enum.map(fn e -> e.email end)
  end
end
