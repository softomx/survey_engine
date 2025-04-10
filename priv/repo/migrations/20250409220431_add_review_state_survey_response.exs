defmodule SurveyEngine.Repo.Migrations.AddReviewStateSurveyResponse do
  use Ecto.Migration

  def change do
    alter table(:survey_responses) do
      add(:review_state, :string, default: "pending")
    end

    create(index(:survey_responses, [:review_state]))
  end
end
