defmodule SurveyEngine.Accounts.AdminNotifier do
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
end
