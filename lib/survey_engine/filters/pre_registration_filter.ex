defmodule SurveyEngine.Filters.PreRegistrationFilter do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :languages, {:array, :string}
    field :agency_name, :string
    field :countries, {:array, :string}
    field :towns, {:array, :string}
    field :agency_types, {:array, :string}
    field :business_models, {:array, :string}
    field :status, {:array, :string}
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [
      :languages,
      :agency_name,
      :countries,
      :towns,
      :agency_types,
      :business_models,
      :status
    ])
  end
end
