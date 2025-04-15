defmodule SurveyEngine.Repo.Migrations.AddUserIdResponseItem do
  use Ecto.Migration

  def change do
    alter table(:survey_response_items) do
      add :editor_user_id, references(:users, on_delete: :nothing)
    end
  end
end
