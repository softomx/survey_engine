defmodule SurveyEngine.Repo.Migrations.AddActiveUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active, :boolean, default: true
    end
  end
end
