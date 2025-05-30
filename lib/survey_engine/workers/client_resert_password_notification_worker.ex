defmodule SurveyEngine.Workers.ClientResertPasswordNotificationWorker do
  alias SurveyEngine.Accounts.{UserNotifier}
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Notifications
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts

  def perform(user_id, site_config_id, locale, client_url) do
    with {:ok, user} <- Accounts.get_user(user_id),
         {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, notification_config} <- Notifications.get_notification_by_action("register") do
      notify_client(user, client_url, site_config, locale, notification_config)
    end
  end

  defp notify_client(user, client_url, site_config, locale, notification_config) do
    with {:ok, content} <-
           get_content_by_language(notification_config.contents, locale) do
      UserNotifier.deliver_reset_password_instructions(
        user,
        "Restablecer contraseña",
        %{content: content, url: client_url, locale: locale},
        site_config.id
      )
    end
  end

  defp get_content_by_language([], _), do: {:error, "no se encuentra el contenido del mensaje"}

  defp get_content_by_language(contents, language) do
    contents
    |> Enum.find(&(&1.language == language))
    |> case do
      nil -> {:ok, contents |> List.first()}
      content -> {:ok, content}
    end
  end
end
