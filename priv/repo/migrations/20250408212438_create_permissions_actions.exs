defmodule SurveyEngine.Repo.Migrations.CreatePermissionsActions do
  use Ecto.Migration

  def change do
    create table(:permissions_actions) do
      add :name, :string
      add :slug, :string
      add :path, :string
      add :action, :string
      add :resource, :string

      timestamps(type: :utc_datetime)
    end
  end
end
