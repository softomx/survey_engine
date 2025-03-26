defmodule SurveyEngine.Mailer.MailerManager do
  alias SurveyEngine.Repo
  alias SurveyEngine.Mailer.MailerConfiguration

  def get_mailer_configuration(id) do
    get_specific_mailer_configuration(id)
    # |> case do
    #   nil -> get_global_mailer_configuration(id)
    #   mailer_config -> mailer_config
    # end
  end

  defp get_specific_mailer_configuration(id) do
    MailerConfiguration
    |> SurveyEngine.Repo.get(id)
  end

  def change_mailer_config(mailer_config, attrs \\ %{}) do
    mailer_config
    |> MailerConfiguration.changeset(attrs)
  end

  def list_mailer_config() do
    Repo.all(MailerConfiguration)
  end

  def get_mailer_config!(id) do
    Repo.get(MailerConfiguration, id)
  end

  def create_mailer_config(attrs) do
    %MailerConfiguration{}
    |> MailerConfiguration.changeset(attrs)
    |> Repo.insert()
  end

  def update_mailer_config(mailer_config, attrs) do
    mailer_config
    |> MailerConfiguration.changeset(attrs)
    |> Repo.update()
  end

  # defp get_global_mailer_configuration(_id) do
  #   MailerConfiguration
  #   |> SurveyEngine.Repo.get_by(id: "global")
  # end
end
