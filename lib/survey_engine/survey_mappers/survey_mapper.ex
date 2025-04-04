defmodule SurveyEngine.SurveyMappers.SurveyMapper do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_mapper" do
    field :type, :string
    field :field, :string
    field :question_id, :string
    belongs_to :survey, SurveyEngine.LeadsForms.LeadsForm, foreign_key: :survey_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(survey_mapper, attrs) do
    survey_mapper
    |> cast(attrs, [:field, :question_id, :type, :survey_id])
    |> validate_required([:field, :question_id, :type, :survey_id])
  end
end
