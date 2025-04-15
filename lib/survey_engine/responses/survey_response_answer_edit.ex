defmodule SurveyEngine.Responses.SurveyResponseAnswerEdit do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :date, :date
    field :open_text, :string
    field :choice_single, :string
    field :choice_multiple, {:array, :string}
  end

  @doc false
  def changeset(response_item, attrs, "date") do
    response_item
    |> cast(attrs, [:date])
    |> validate_required([:date])
  end

  @doc false
  def changeset(response_item, attrs, "openText") do
    response_item
    |> cast(attrs, [:open_text])
    |> validate_required([:open_text])
  end

  @doc false
  def changeset(response_item, attrs, "multipleChoiceSingle") do
    response_item
    |> cast(attrs, [:choice_single])
    |> validate_required([:choice_single])
  end

  @doc false
  def changeset(response_item, attrs, "multipleChoiceMulti") do
    response_item
    |> cast(attrs, [:choice_multiple])
    |> validate_required([:choice_multiple])
    |> validate_length(:choice_multiple, min: 1)
  end

  def changeset(response_item, attrs, _type) do
    response_item
    |> cast(attrs, [])
  end
end
