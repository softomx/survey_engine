defmodule SurveyEngine.Repo.Migrations.CreatePermissionsRolesActions do
  use Ecto.Migration

  def change do
    create table(:permissions_roles_actions) do
      add :role_id, references(:roles, on_delete: :nothing)
      add :permission_action_id, references(:permissions_actions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:permissions_roles_actions, [:role_id])
    create index(:permissions_roles_actions, [:permission_action_id])
  end
end
