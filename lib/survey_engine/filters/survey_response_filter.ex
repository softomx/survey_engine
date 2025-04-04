defmodule SurveyEngine.Filters.SurveyResponseFilter do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :states, {:array, :string}
    field :form_group_id, :id
    embeds_one :company_filter, CompanyFilter, primary_key: false do
      @derive Jason.Encoder
      field :agency_name, :string
      field :countries, {:array, :string}
      field :agency_types, {:array, :string}
      field :business_models, {:array, :string}
    end

    embeds_one :register_dates, RegisterDates, primary_key: false do
      @derive Jason.Encoder
      field :start_date, :date
      field :end_date, :date
    end
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [
      :states,
      :form_group_id
    ])
    |> cast_embed(:register_dates, with: &changeset_dates/2)
    |> cast_embed(:company_filter, with: &changeset_company/2)
  end

  def changeset_dates(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:start_date, :end_date])
  end

  def changeset_company(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:agency_name, :countries, :agency_types, :business_models])
  end
end
