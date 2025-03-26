defmodule SurveyEngine.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :date, :string
    field :language, :string
    field :agency_name, :string
    field :rfc, :string
    field :legal_name, :string
    field :country, :string
    field :town, :string
    field :city, :string
    field :agency_type, :string
    field :billing_currency, :string
    belongs_to :business_model, SurveyEngine.BusinessModels.BusinessModel
    field :status, :string, default: "pending"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [
      :date,
      :language,
      :agency_name,
      :rfc,
      :legal_name,
      :country,
      :town,
      :city,
      :agency_type,
      :billing_currency,
      :status,
      :business_model_id
    ])
    |> validate_required([
      :date,
      :language,
      :legal_name,
      :country,
      :town,
      :city,
      :agency_type,
      :billing_currency
    ])
  end
end
