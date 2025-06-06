defmodule SurveyEngine.Accounts.AdminNotifier do
  use Phoenix.Swoosh, view: SurveyEngineWeb.UserNotifierView
  import Swoosh.Email

  # Delivers the email using the application mailer.

  defp deliver(template, recipients, subject, content, config_id) when is_list(recipients) do
    recipients
    |> Enum.map(fn recipient ->
      email =
        new()
        |> to(recipient)
        |> subject(subject)
        |> render_body(template, content)

      SurveyEngine.Mailer.MailerHelper.deliver_email(email, config_id)
    end)
  end

  defp deliver(template, recipient, subject, content, config_id) do
    email =
      new()
      |> to(recipient)
      |> subject(subject)
      |> render_body(template, content)

    SurveyEngine.Mailer.MailerHelper.deliver_email(email, config_id)
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_new_register(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_register.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_register_updated(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_register_updated.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_business_model_assigned(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_business_model_assigned.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_executive_account_assigned(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_executive_account_assigned.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_survey_updated(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_survey_updated.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_reset_user_password(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_reset_password_notification.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_rejected_survey(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_survey_rejected.html",
      to,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_approved_survey(
        to,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "admin_survey_approved.html",
      to,
      subject,
      content,
      site_config_id
    )
  end
end
