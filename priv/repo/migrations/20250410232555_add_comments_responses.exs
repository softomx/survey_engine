defmodule SurveyEngine.Repo.Migrations.AddCommentsResponses do
  use Ecto.Migration

  def change do
    alter table(:survey_responses) do
      add :review_comments, :text
    end
  end
end
