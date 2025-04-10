defmodule SurveyEngine.Repo.Migrations.AddExtraConfigAndSurverProvider do
  use Ecto.Migration

  def change do
    alter table(:site_configurations) do
      add(:extra_config, :map, default: %{})
      add(:survey_providers, {:array, :map}, default: [])
    end
  end
end
