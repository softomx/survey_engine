defmodule SurveyEngine.Catalogs.AgencyModel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agency_models" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(agency_model, attrs) do
    agency_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
