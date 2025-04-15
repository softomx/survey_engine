defmodule SurveyEngine.AffiliateEngine.Affiliate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "affiliates" do
    field :survey_id, :id, virtual: true
    field :name, :string
    field :affiliate_slug, :string
    # fiscal_name
    field :trading_name, :string
    field :business_name, :string
    field :rfc, :string
    field :agency_model, :string, source: :company_type
    field :agency_type, :string
    field :base_currency, :string
    field :external_affiliate_id, :string
    field :state, :string, default: "draft"
    belongs_to :company, SurveyEngine.Companies.Company
    embeds_one :address, SurveyEngine.AffiliateEngine.Address, on_replace: :update
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
      :agency_model,
      :company_id,
      :external_affiliate_id,
      :state
    ])
    |> validate_required([
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :agency_model,
      :company_id,
      :state
    ])
    |> cast_embed(:address)
  end
end
