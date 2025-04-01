defmodule SurveyEngine.Repo.Migrations.AddDescriptionModelBusiness do
  use Ecto.Migration

  def change do
    alter table(:business_models) do
      add :description, :text
    end
  end
end
