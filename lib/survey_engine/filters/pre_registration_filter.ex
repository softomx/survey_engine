defmodule SurveyEngine.Filters.PreRegistrationFilter do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :languages, {:array, :string}
    field :agency_name, :string
    field :legal_name, :string
    field :countries, {:array, :string}
    field :towns, {:array, :string}
    field :agency_types, {:array, :string}
    field :business_models, {:array, :string}
    field :status, {:array, :string}
    embeds_one :register_dates, RegisterDates, [primary_key: false] do
      @derive Jason.Encoder
      field :start_date, :date
      field :end_date, :date
    end
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [
      :languages,
      :agency_name,
      :legal_name,
      :countries,
      :towns,
      :agency_types,
      :business_models,
      :status
    ])
    |> cast_embed(:register_dates, with: &changeset_dates/2)
  end

  def changeset_dates(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:start_date, :end_date])
  end
end
