defmodule SurveyEngine.Repo.Migrations.CreateSiteConfigurations do
  use Ecto.Migration

  def change do
    create table(:site_configurations) do
      add :name, :string
      add :url, :string
      add :tenant, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
