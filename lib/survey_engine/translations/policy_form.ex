defmodule SurveyEngine.Translations.PolicyForm do
  use Ecto.Schema
  import Ecto.Changeset
  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field :url, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_required([:url])
  end
end
