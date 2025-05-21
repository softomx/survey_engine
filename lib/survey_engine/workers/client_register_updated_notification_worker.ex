defmodule SurveyEngine.Workers.ClientRegisterUpdatedNotificationWorker do
  alias SurveyEngine.Accounts.{UserNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(company_id, site_config_id, client_url) do
    with {:ok, user} <- Accounts.get_user_by_company(company_id),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(user.company_id),
         {:ok, notification_config} <-
           Notifications.get_notification_by_action("register_updated") do
      notify_client(user, company, client_url, site_config, notification_config)
    end
  end

  defp notify_client(user, company, client_url, site_config, notification_config) do
    with {:ok, content} <-
           get_content_by_language(notification_config.contents, company.language),
         {:ok, subject} <- get_content_by_language(notification_config.subjects, company.language) do
      UserNotifier.deliver_register_updated(
        user,
        subject.description,
        %{content: content, url: client_url, company: company},
        site_config.id
      )
    end
  end

  defp get_content_by_language([], _), do: {:error, "no se encuentra elcontenido delmensaje"}

  defp get_content_by_language(contents, language) do
    contents
    |> Enum.find(&(&1.language == language))
    |> case do
      nil -> {:ok, contents |> List.first()}
      content -> {:ok, content}
    end
  end
end
