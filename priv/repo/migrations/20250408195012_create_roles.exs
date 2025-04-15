defmodule SurveyEngine.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :slug, :string

      timestamps(type: :utc_datetime)
    end
  end
end
