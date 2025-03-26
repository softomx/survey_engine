defmodule SurveyEngine.Repo.Migrations.CreateFormGroups do
  use Ecto.Migration

  def change do
    create table(:form_groups) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
