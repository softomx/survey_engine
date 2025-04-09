defmodule SurveyEngine.Accounts.UserRole do
  alias SurveyEngine.Accounts.User
  alias SurveyEngine.Accounts.Role
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_roles" do
    belongs_to(:role, Role)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role_id, :user_id])
    |> validate_required([])
  end
end
