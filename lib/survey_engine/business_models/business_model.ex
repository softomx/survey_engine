defmodule SurveyEngine.BusinessModels.BusinessModel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "business_models" do
    field :name, :string

    has_many :business_config, SurveyEngine.BusinessModels.BusinessConfig

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(business_model, attrs) do
    business_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
