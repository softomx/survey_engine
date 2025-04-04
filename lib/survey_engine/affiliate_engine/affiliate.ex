defmodule SurveyEngine.AffiliateEngine.Affiliate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "affiliates" do
    field :name, :string
    field :affiliate_slug, :string
    field :trading_name, :string
    field :business_name, :string
    field :rfc, :string
    field :company_type, :string
    belongs_to :company, SurveyEngine.Companies.Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(affiliate, attrs) do
    affiliate
    |> cast(attrs, [:name, :affiliate_slug, :trading_name, :business_name, :rfc, :company_type])
    |> validate_required([
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :company_type
    ])
  end
end
