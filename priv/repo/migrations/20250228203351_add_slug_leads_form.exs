defmodule SurveyEngine.Repo.Migrations.AddSlugLeadsForm do
  use Ecto.Migration

  def change do
    alter table(:leads_forms) do
      add :slug, :string
      add :provider, :string
      add :behaviour, :string, default: "affilite_register"
    end
  end
end
