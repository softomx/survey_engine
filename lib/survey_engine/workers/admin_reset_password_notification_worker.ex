defmodule SurveyEngine.Workers.AdminResetPasswordNotificationWorker do
  alias SurveyEngine.Accounts.{AdminNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(user_id, site_config_id) do
    with {:ok, user} <- Accounts.get_user(user_id),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(user.company_id),
         {:ok, notification_config} <- Notifications.get_notification_by_action("reset_password"),
         {:ok, emails} <- {:ok, get_emails(notification_config)} do
      AdminNotifier.deliver_reset_user_password(
        emails,
        "Cambio contraseña",
        %{company: company, user: user, site_config: site_config},
        site_config.id
      )
    end
  end

  defp get_emails(notification_config) do
    notification_config.to
    |> Enum.map(fn e -> e.email end)
  end
end
