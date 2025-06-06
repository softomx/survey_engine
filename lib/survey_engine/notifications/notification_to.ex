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
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: SurveyEngine.TransaleteHelper.changeset_error(:invalid_email)
    )
    |> validate_length(:email, max: 160)
  end
end
