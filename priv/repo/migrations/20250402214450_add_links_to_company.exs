defmodule SurveyEngine.Repo.Migrations.AddLinksToCompany do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :links, {:array, :map}
    end
  end
end
