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
    field :agency_models, {:array, :string}
    field :business_models, {:array, :string}
    field :status, {:array, :string}

    embeds_one :register_dates, RegisterDates, primary_key: false do
      @derive Jason.Encoder
      field :start_date, :date
      field :end_date, :date
      field :label_dates, :string
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
      :status,
      :agency_models
    ])
    |> cast_embed(:register_dates, with: &changeset_dates/2)
  end

  def changeset_dates(struct, attrs \\ %{}) do
    attrs = attrs |> cast_dates_from_label_dates()

    struct
    |> cast(attrs, [:start_date, :end_date, :label_dates])
  end

  defp cast_dates_from_label_dates(attrs) do
    if !is_nil(attrs["start_date"]) or !is_nil(attrs["end_date"]) do
      attrs
    else
      if attrs["label_date"] do
        date_ranges = attrs["label_dates"] |> String.split("a")

        attrs
        |> Map.put("start_date", date_ranges |> List.first())
        |> Map.put("end_date", date_ranges |> List.last())
      else
        attrs
      end
    end
  end
end
