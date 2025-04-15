defmodule SurveyEngine.AffiliateEngine.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:street, :string)
    field(:internal_number, :string)
    field(:external_number, :string)
    field(:neighborhood, :string)
    field(:city, :string)
    field(:country, :string)
    field(:state, :string)
    field(:postal_code, :string)
    field(:location, :string)
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [
      :street,
      :neighborhood,
      :city,
      :country,
      :state,
      :postal_code,
      :external_number,
      :location,
      :internal_number
    ])
    |> validate_required([
      :street,
      :internal_number,
      :neighborhood,
      :country,
      :postal_code,
      :city,
      :external_number
    ])
  end
end
