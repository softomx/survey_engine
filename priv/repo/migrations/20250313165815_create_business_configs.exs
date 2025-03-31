defmodule SurveyEngine.Repo.Migrations.CreateBusinessConfigs do
  use Ecto.Migration

  def change do
    create table(:business_configs) do
      add :order, :integer
      add :required, :boolean, default: false, null: false
      add :previous_lead_form_finished, {:array, :id}

      add :business_model_id, references(:business_models, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:business_configs, [:business_model_id])
  end
end
