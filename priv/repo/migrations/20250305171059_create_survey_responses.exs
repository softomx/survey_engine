defmodule SurveyEngine.Repo.Migrations.CreateSurveyResponses do
  use Ecto.Migration

  def change do
    create table(:survey_responses) do
      add :date, :date
      add :state, :string
      add :data, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :lead_form_id, references(:leads_forms, on_delete: :nothing)
      add :external_id, :string
      timestamps(type: :utc_datetime)
    end

    create index(:survey_responses, [:user_id])
  end
end
