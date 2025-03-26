defmodule SurveyEngine.Workers.ClientBusinessModelAssignedNotificationWorker do
  alias SurveyEngine.Accounts.{UserNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(company_id, site_config_id) do
    with {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, company} <- Companies.get_company(company_id),
         {:ok, user} <- Accounts.get_user_by_company(company_id),
         {:ok, notification_config} <-
           Notifications.get_notification_by_action("assign_busines_model") do
      notify_client(user, company, site_config, notification_config)
    end
  end

  defp notify_client(user, company, site_config, notification_config) do
    with {:ok, content} <-
           get_content_by_language(notification_config.contents, company.language),
         {:ok, subject} <- get_content_by_language(notification_config.subjects, company.language) do
      UserNotifier.deliver_business_model_assigned(
        user,
        subject.description,
        %{content: content, company: company},
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
