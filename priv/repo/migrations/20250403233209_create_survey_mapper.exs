defmodule SurveyEngine.Repo.Migrations.CreateSurveyMapper do
  use Ecto.Migration

  def change do
    create table(:survey_mapper) do
      add :field, :string
      add :question_id, :string
      add :type, :string
      add :survey_id, references(:leads_forms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:survey_mapper, [:survey_id])
  end
end
