defmodule SurveyEngine.Workers.AdminBusinessModelAssignedNotificationWorker do
  alias SurveyEngine.Accounts.{AdminNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(company_id, site_config_id) do
    with {:ok, user} <- Accounts.get_user_by_company(company_id),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(company_id),
         {:ok, notification_config} <-
           Notifications.get_notification_by_action("assign_busines_model"),
         {:ok, emails} <- {:ok, get_emails(notification_config)} do
      AdminNotifier.deliver_business_model_assigned(
        emails,
        "Modelo de negocio asignado",
        %{company: company, user: user, site_config: site_config, locale: company.language},
        site_config.id
      )
    end
  end

  defp get_emails(notification_config) do
    notification_config.to
    |> Enum.map(fn e -> e.email end)
  end
end
