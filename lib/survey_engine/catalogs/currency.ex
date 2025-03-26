defmodule SurveyEngine.Catalogs.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :active, :boolean, default: false
    field :name, :string
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :slug, :active])
    |> validate_required([:name, :slug, :active])
  end
end
