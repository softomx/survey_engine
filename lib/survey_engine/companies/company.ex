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
    field :agency_model, :string
    field :agency_type, :string
    field :billing_currency, :string
    field :user_id, :id
    belongs_to :business_model, SurveyEngine.BusinessModels.BusinessModel
    # pending,assigned,finished, approved, rejected, created
    field :status, :string, default: "pending"
    field :phone, :string
    has_one :ejecutive, SurveyEngine.Accounts.User
    embeds_many :links, SurveyEngine.Companies.CompanyLink, on_replace: :delete
    has_one :affiliate, SurveyEngine.AffiliateEngine.Affiliate, on_replace: :delete

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
      :business_model_id,
      :agency_model,
      :user_id,
      :phone,
      :ejecutive_id
    ])
    |> validate_required([
      :language,
      :legal_name,
      :country,
      :town,
      :city,
      :agency_type,
      :billing_currency,
      :agency_model,
      :phone
    ])
    |> cast_embed(:links, sort_param: :links_sort, drop_param: :links_drop)
    |> unmask_phone()
  end

  defp unmask_phone(changeset) do
    if value = get_field(changeset, :phone) do
      changeset |> put_change(:phone, value |> String.replace(~r/[\(\)\-\_]/, ""))
    else
      changeset
    end
  end
end
