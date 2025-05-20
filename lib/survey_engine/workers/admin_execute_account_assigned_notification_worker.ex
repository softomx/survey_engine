defmodule SurveyEngine.Workers.AdminExecutiveAccountAssignedNotificationWorker do
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
           Notifications.get_notification_by_action("assign_executive_account"),
         {:ok, emails} <- {:ok, get_emails(notification_config, company)} do
      AdminNotifier.deliver_executive_account_assigned(
        emails,
        "Ejecutivo de cuenta asignado",
        %{
          company: company,
          user: user,
          site_config: site_config,
          locale: company.language
        },
        site_config.id
      )
    end
  end

  defp get_emails(notification_config, company) do
    ccp =
      notification_config.to
      |> Enum.map(fn e -> e.email end)

    if company.ejecutive_id do
      user = Accounts.get_user!(company.ejecutive_id)
      [user.email | ccp]
    else
      ccp
    end
  end
end
