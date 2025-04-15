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
    belongs_to :created_by, SurveyEngine.Accounts.User
    belongs_to :sync_by, SurveyEngine.Accounts.User
    field :sync_date, :utc_datetime
    belongs_to :company, SurveyEngine.Companies.Company
    embeds_one :address, SurveyEngine.AffiliateEngine.Address, on_replace: :update
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(affiliate, attrs) do
    country = attrs["address"]["country"]

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
      :state,
      :base_currency,
      :agency_type,
      :created_by_id,
      :sync_by_id,
      :sync_date
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
    |> validate_rfc(country)
    |> cast_embed(:address)
  end

  defp validate_rfc(changeset, "MX") do
    changeset
    |> validate_required([:rfc])
  end

  defp validate_rfc(changeset, _) do
    changeset
  end
end
