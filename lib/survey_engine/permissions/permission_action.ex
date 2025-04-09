defmodule SurveyEngine.Permissions.PermissionAction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions_actions" do
    field :name, :string
    field :path, :string
    field :resource, :string
    field :action, :string
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission_action, attrs) do
    permission_action
    |> cast(attrs, [:name, :slug, :path, :action, :resource])
    |> validate_required([:name, :slug, :path, :action, :resource])
  end
end
