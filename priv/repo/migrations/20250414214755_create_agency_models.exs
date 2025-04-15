defmodule SurveyEngine.Repo.Migrations.CreateAgencyModels do
  use Ecto.Migration

  def change do
    create table(:agency_models) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
