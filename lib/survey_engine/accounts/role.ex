defmodule SurveyEngine.Accounts.Role do
  alias SurveyEngine.Permissions.PermissionRoleAction
  alias SurveyEngine.Permissions.PermissionAction
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name, :slug], sortable: [:name]
  }


  schema "roles" do
    field :name, :string
    field :slug, :string
    many_to_many(:permission_actions, PermissionAction, join_through: PermissionRoleAction, join_keys: [role_id: :id, permission_action_id: :id],  on_replace: :delete)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end

  def changeset_role_actions(role, actions) do
    role
    |> change()
    |> put_assoc(:permission_actions, actions)
  end
end
