defmodule SurveyEngine.Accounts.UserNotifier do
  use Phoenix.Swoosh, view: SurveyEngineWeb.UserNotifierView
  import Swoosh.Email

  # Delivers the email using the application mailer.
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
  def deliver_confirmation_instructions(
        user,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "client_register.html",
      user.email,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_business_model_assigned(
        user,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "client_business_model_assigned.html",
      user.email,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_survey_updated(
        user,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "client_survey_updated.html",
      user.email,
      subject,
      content,
      site_config_id
    )
  end

  def deliver_reset_password_instructions(
        user,
        subject,
        content,
        site_config_id
      ) do
    deliver(
      "client_reset_password_notification.html",
      user.email,
      subject,
      content,
      site_config_id
    )
  end

  @doc """
  Deliver instructions to reset a user password.
  """

  # def deliver_reset_password_instructions(user, url) do
  #   deliver(
  #     user.email,
  #     "Reset password instructions",
  #     """

  #     ==============================

  #     Hi #{user.email},

  #     You can reset your password by visiting the URL below:

  #     #{url}

  #     If you didn't request this change, please ignore this.

  #     ==============================
  #     """,
  #     1
  #   )
  # end

  @doc """
  Deliver instructions to update a user email.
  """
  # def deliver_update_email_instructions(user, url) do
  #   deliver(
  #     user.email,
  #     "Update email instructions",
  #     """

  #     ==============================

  #     Hi #{user.email},

  #     You can change your email by visiting the URL below:

  #     #{url}

  #     If you didn't request this change, please ignore this.

  #     ==============================
  #     """,
  #     1
  #   )
  # end
end
