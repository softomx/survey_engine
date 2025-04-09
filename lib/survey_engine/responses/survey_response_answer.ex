defmodule SurveyEngine.Responses.SurveyResponseItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_response_items" do
    field :type, :string
    field :index, :integer
    field :answer, :map
    field :question, :string
    field :question_id, :string
    belongs_to :survey_response, SurveyEngine.Responses.SurveyResponse
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(survey_response, attrs) do
    survey_response
    |> cast(attrs, [:type, :index, :answer, :question, :question_id, :survey_response_id])
    |> validate_required([:type, :index, :answer, :question, :question_id, :survey_response_id])
  end
end
