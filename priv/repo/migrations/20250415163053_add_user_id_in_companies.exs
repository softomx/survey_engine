defmodule SurveyEngine.Repo.Migrations.AddUserIdInCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
