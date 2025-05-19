defmodule SurveyEngine.Catalogs.AgencyModel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agency_models" do
    field :name, :string

    has_many :descriptions, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "agency_models", behaviour: "description"]

    has_many :translates, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "agency_models", behaviour: "name"]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(agency_model, attrs) do
    agency_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
