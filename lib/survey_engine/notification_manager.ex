defmodule SurveyEngine.NotificationManager do
  alias SurveyEngine.Accounts
  alias SurveyEngine.Responses.SurveyResponse
  alias SurveyEngine.Companies.Company
  alias SurveyEngine.Accounts.User

  alias SurveyEngine.Repo
  alias SurveyEngine.Accounts.UserToken
  alias SurveyEngine.SiteConfigurations.SiteConfiguration

  def register_lead_notification(
        %User{} = user,
        %SiteConfiguration{} = site_config,
        confirmation_url_fun
      ) do
    with {:ok, {encoded_token, user_token}} <-
           {:ok, UserToken.build_email_token(user, "confirm")},
         {:ok, _} <- Repo.insert(user_token),
         {:ok, url} <- {:ok, confirmation_url_fun.(encoded_token)} do
      enqueue_worker(SurveyEngine.Workers.ClientRegisterNotificationWorker, [
        user.id,
        site_config.id,
        url
      ])

      enqueue_worker(SurveyEngine.Workers.AdminRegisterNotificationWorker, [
        user.id,
        site_config.id
      ])
    end
  end

  def notify_register_updated(
        company,
        url,
        %SiteConfiguration{} = site_config
      ) do
    enqueue_worker(SurveyEngine.Workers.ClientRegisterUpdatedNotificationWorker, [
      company.id,
      site_config.id,
      url
    ])

    enqueue_worker(SurveyEngine.Workers.AdminRegisterUpdatedNotificationWorker, [
      company.id,
      site_config.id
    ])
  end

  def resert_password_notification(
        %User{} = user,
        %SiteConfiguration{} = site_config,
        locale,
        resert_url_fun
      ) do
    with {:ok, {encoded_token, user_token}} <-
           {:ok, UserToken.build_email_token(user, "reset_password")},
         {:ok, _} <- Repo.insert(user_token),
         {:ok, url} <- {:ok, resert_url_fun.(encoded_token)} do
      enqueue_worker(SurveyEngine.Workers.ClientResertPasswordNotificationWorker, [
        user.id,
        site_config.id,
        locale,
        url
      ])

      enqueue_worker(SurveyEngine.Workers.AdminResetPasswordNotificationWorker, [
        user.id,
        site_config.id
      ])
    end
  end

  def notify_created_affiliate(
        %User{} = user,
        %SiteConfiguration{} = site_config,
        company_id
      ) do
    enqueue_worker(SurveyEngine.Workers.ClientCreatedAffiliateWorker, [
      user.id,
      site_config.id,
      company_id
    ])
  end

  def notify_business_model_assigned(
        %Company{} = company,
        url,
        %SiteConfiguration{} = site_config
      ) do
    enqueue_worker(
      SurveyEngine.Workers.ClientBusinessModelAssignedNotificationWorker,
      [
        company.id,
        url,
        site_config.id
      ]
    )

    enqueue_worker(
      SurveyEngine.Workers.AdminBusinessModelAssignedNotificationWorker,
      [
        company.id,
        site_config.id
      ]
    )
  end

  def notify_executive_account_assigned(
        %Company{} = company,
        url,
        %SiteConfiguration{} = site_config
      ) do
    enqueue_worker(
      SurveyEngine.Workers.ClientExecutiveAccountAssignedNotificationWorker,
      [
        company.id,
        url,
        site_config.id
      ]
    )

    enqueue_worker(
      SurveyEngine.Workers.AdminExecutiveAccountAssignedNotificationWorker,
      [
        company.id,
        site_config.id
      ]
    )
  end

  def notify_survey_finished(%SurveyResponse{} = response, site_config_id) do
    with {:ok, user} <- Accounts.get_user(response.user_id) do
      enqueue_worker(
        SurveyEngine.Workers.ClientSurveyUpdatedNotificationWorker,
        [
          response.id,
          user.company_id,
          site_config_id
        ]
      )

      enqueue_worker(
        SurveyEngine.Workers.AdminSurveyUpdatedNotificationWorker,
        [
          response.id,
          user.company_id,
          site_config_id
        ]
      )
    end
  end

  def notify_review_survey(
        %SurveyResponse{} = survey_response,
        %SiteConfiguration{} = site_config
      ) do
    enqueue_worker(
      SurveyEngine.Workers.ClientReviewSurveyNotificationWorker,
      [
        survey_response.id,
        site_config.id
      ]
    )

    enqueue_worker(
      SurveyEngine.Workers.AdminReviewSurveyNotificationWorker,
      [
        survey_response.id,
        site_config.id
      ]
    )
  end

  defp enqueue_worker(module, options) do
    Exq.enqueue(
      Exq,
      "survey_notifications",
      module,
      options
    )
  end
end
