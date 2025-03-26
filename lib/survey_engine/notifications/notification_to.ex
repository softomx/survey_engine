defmodule SurveyEngine.Notifications.NotificationTo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
  end

  def changeset(to, attrs) do
    to
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
  end
end
