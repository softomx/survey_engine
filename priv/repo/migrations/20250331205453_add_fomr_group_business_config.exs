defmodule SurveyEngine.Repo.Migrations.AddFomrGroupBusinessConfig do
  use Ecto.Migration

  def change do
    alter table(:business_configs) do
      add :form_group_id, references(:form_groups, on_delete: :nothing)
    end

    create index(:business_configs, [:form_group_id])
  end
end
