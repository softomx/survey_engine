defmodule SurveyEngine.Mailer.MailerHelper do
  # use Phoenix.Swoosh, view: SurveyEngineWeb.PageHTML
  import Swoosh.Email
  alias SurveyEngine.Mailer, as: Mailer
  alias SurveyEngine.Mailer.MailerConfiguration
  alias SurveyEngine.Mailer.MailerManager

  def deliver_email(%Swoosh.Email{} = email, config_id) do
    config = MailerManager.get_mailer_configuration(config_id)
    deliver_with_custom_config(email, config)
  end

  defp build_mailer_configuration(%MailerConfiguration{} = config) do
    []
    |> add_mailer_specific_config(config.adapter, config)
  end

  defp deliver_with_custom_config(%Swoosh.Email{} = email, %MailerConfiguration{} = config) do
    email
    |> from(format_from(config))
    |> Mailer.deliver(build_mailer_configuration(config))
  end

  defp add_mailer_specific_config(mailer_config, adapter, config) do
    case adapter do
      "amazon_ses" -> build_aws_config(mailer_config, config)
      "sparkpost" -> build_sparkpost_config(mailer_config, config)
      "mailjet" -> build_mailjet_config(mailer_config, config)
      "mailgun" -> build_mailgun_config(mailer_config, config)
    end
  end

  defp build_aws_config(mailer_config, config) do
    mailer_config
    |> Keyword.put(:secret, config.configuration.secret)
    |> Keyword.put(:access_key, config.configuration.access_key)
    |> Keyword.put(:region, config.configuration.region)
    |> Keyword.put(:adapter, Swoosh.Adapters.AmazonSES)
  end

  defp build_sparkpost_config(mailer_config, config) do
    mailer_config
    |> Keyword.put(:api_key, config.configuration.api_key)
    |> Keyword.put(:adapter, Swoosh.Adapters.SparkPost)
  end

  defp build_mailjet_config(mailer_config, config) do
    mailer_config
    |> Keyword.put(:api_key, config.configuration.api_key)
    |> Keyword.put(:secret, config.configuration.secret)
    |> Keyword.put(:adapter, Swoosh.Adapters.Mailjet)
  end

  defp build_mailgun_config(mailer_config, config) do
    mailer_config
    |> Keyword.put(:api_key, config.configuration.api_key)
    |> Keyword.put(:domain, config.configuration.domain)
    |> Keyword.put(:adapter, Swoosh.Adapters.Mailgun)
  end

  defp format_from(%MailerConfiguration{} = config) do
    if !is_nil(config.email_name) do
      {config.email_name, config.email_from}
    else
      config.email_from
    end
  end
end
