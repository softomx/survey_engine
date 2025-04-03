defmodule SurveyEngine.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:agency_type, :legal_name, :status, :business_model_id], sortable: [:agency_type]
  }

  schema "companies" do
    field :language, :string
    field :agency_name, :string
    field :legal_name, :string
    field :country, :string
    field :town, :string
    field :city, :string
    field :agency_type, :string
    field :billing_currency, :string
    belongs_to :business_model, SurveyEngine.BusinessModels.BusinessModel
    field :status, :string, default: "pending"
    embeds_many :links, SurveyEngine.Companies.CompanyLink, on_replace: :delete
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [
      :language,
      :agency_name,
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
      :language,
      :legal_name,
      :country,
      :town,
      :city,
      :agency_type,
      :billing_currency
    ])
    |> cast_embed(:links, sort_param: :links_sort, drop_param: :links_drop)
  end
end
