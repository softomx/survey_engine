defmodule SurveyEngine.Repo.Migrations.AddSyncInfoAffiliate do
  use Ecto.Migration

  def change do
    alter table(:affiliates) do
      add :sync_by_id, references(:users, on_delete: :nothing)
      add :sync_date, :utc_datetime
      add :created_by_id, references(:users, on_delete: :nothing)
    end
  end
end
