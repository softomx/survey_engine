defmodule SurveyEngine.Repo.Migrations.AddResponseItem do
  use Ecto.Migration

  def change do
    create table(:survey_response_items) do
      add :type, :string
      add :index, :integer
      add :answer, :map
      add :question, :string
      add :question_id, :string

      add :survey_response_id,
          references(:survey_responses, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end
  end
end
