defmodule SurveyEngine.Repo.Migrations.CreateBusinessModels do
  use Ecto.Migration

  def change do
    create table(:business_models) do
      add :name, :string
      add :slug, :string

      timestamps(type: :utc_datetime)
    end
  end
end
