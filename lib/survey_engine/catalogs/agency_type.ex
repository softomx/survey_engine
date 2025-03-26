defmodule SurveyEngine.Catalogs.AgencyType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agency_types" do
    field :active, :boolean, default: false
    field :name, :string

    has_many :descriptions, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "agency_types", behaviour: "description"]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(agency_type, attrs) do
    agency_type
    |> cast(attrs, [:name, :active])
    |> validate_required([:name, :active])
  end
end
