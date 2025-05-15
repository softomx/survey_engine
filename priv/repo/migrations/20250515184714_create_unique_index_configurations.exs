defmodule SurveyEngine.Repo.Migrations.CreateUniqueIndexConfigurations do
  use Ecto.Migration

  def change do
    create unique_index(:notifications, [:action])
  end
end
