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
    field(:town, :string)
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
      :town,
      :external_number,
      :location
    ])
    |> validate_required([
      :street,
      :external_number,
      :neighborhood,
      :country,
      :postal_code,
      :location
    ])
  end
end
