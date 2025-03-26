defmodule SurveyEngine.Repo.Migrations.AddModelIdToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :business_model_id, references(:business_models, on_delete: :nothing)
    end
  end
end
