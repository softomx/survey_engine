defmodule SurveyEngine.Repo.Migrations.CreateAgencyTypes do
  use Ecto.Migration

  def change do
    create table(:agency_types) do
      add :name, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
