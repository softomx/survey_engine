defmodule SurveyEngine.Workers.ClientExecutiveAccountAssignedNotificationWorker do
  alias SurveyEngine.Accounts.{UserNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(company_id, url, site_config_id) do
    with {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(company_id),
         {:ok, user} <- Accounts.get_user_by_company(company_id),
         {:ok, notification_config} <-
           Notifications.get_notification_by_action("assign_executive_account") do
      notify_client(user, company, site_config, notification_config, url)
    end
    |> IO.inspect()
  end

  defp notify_client(user, company, site_config, notification_config, url) do
    with {:ok, content} <-
           get_content_by_language(notification_config.contents, company.language),
         {:ok, subject} <- get_content_by_language(notification_config.subjects, company.language) do
      UserNotifier.deliver_executive_account_assigned(
        user,
        subject.description,
        %{content: content, company: company, url: url},
        site_config.id
      )
    end
  end

  defp get_content_by_language([], _), do: {:error, "no se encuentra elcontenido del mensaje"}

  defp get_content_by_language(contents, language) do
    contents
    |> Enum.find(&(&1.language == language))
    |> case do
      nil -> {:ok, contents |> List.first()}
      content -> {:ok, content}
    end
  end
end
