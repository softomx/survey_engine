defmodule SurveyEngine.Catalogs.PersonalTitle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "personal_titles" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(personal_title, attrs) do
    personal_title
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
