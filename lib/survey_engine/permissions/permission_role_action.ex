defmodule SurveyEngine.Permissions.PermissionRoleAction do
  alias SurveyEngine.Permissions.PermissionAction
  alias SurveyEngine.Accounts.Role
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions_roles_actions" do
    belongs_to(:role, Role)
    belongs_to(:permission_action, PermissionAction)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission_role_action, attrs) do
    permission_role_action
    |> cast(attrs, [:role_id, :permission_action_id])
    |> validate_required([])
  end
end
