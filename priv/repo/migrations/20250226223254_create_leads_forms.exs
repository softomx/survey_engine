defmodule SurveyEngine.Repo.Migrations.CreateLeadsForms do
  use Ecto.Migration

  def change do
    create table(:leads_forms) do
      add :name, :string
      add :language, :string
      add :external_id, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
