defmodule SurveyEngine.Repo.Migrations.CreatePersonalTitles do
  use Ecto.Migration

  def change do
    create table(:personal_titles) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
