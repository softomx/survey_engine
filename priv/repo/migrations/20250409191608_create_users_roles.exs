defmodule SurveyEngine.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles) do
      add :role_id, references(:roles, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:users_roles, [:role_id])
    create index(:users_roles, [:user_id])
  end
end
