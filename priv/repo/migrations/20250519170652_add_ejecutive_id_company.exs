defmodule SurveyEngine.Repo.Migrations.AddEjecutiveIdCompany do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :ejecutive_id, references(:users)
    end
  end
end
