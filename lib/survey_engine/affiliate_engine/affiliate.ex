defmodule SurveyEngine.AffiliateEngine.Affiliate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "affiliates" do
    field :survey_id, :id, virtual: true
    field :name, :string
    field :affiliate_slug, :string
    field :trading_name, :string
    field :business_name, :string
    field :rfc, :string
    field :company_type, :string
    field :external_affiliate_id, :string, virtual: true
    belongs_to :company, SurveyEngine.Companies.Company
    # embeds_one :address, SurveyEngine.AffiliateEngine.Address
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(affiliate, attrs) do
    affiliate
    |> cast(attrs, [
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :company_type,
      :company_id,
      :external_affiliate_id
    ])
    |> validate_required([
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :company_type,
      :company_id
    ])

    # |> cast_embed(:address)
  end
end
