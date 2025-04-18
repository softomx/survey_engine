defmodule SurveyEngine.Repo.Migrations.CreateMailerConfiguration do
  use Ecto.Migration

  def change do
    create table(:mailer_configurations) do
      add(:configuration, :map, default: %{})
      add(:email_from, :string)
      add(:email_name, :string)
      add(:adapter, :string)
      add(:name, :string)
      add(:site_configuration_id, references(:site_configurations))
      timestamps(type: :utc_datetime)
    end
  end
end
