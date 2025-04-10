defmodule SurveyEngine.Responses.SurveyResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:date, :state, :user_id, :form_group_id], sortable: [:date]
  }

  schema "survey_responses" do
    field :data, :map
    field :date, :date
    field :state, :string
    field :external_id, :string
    field :review_state, :string, default: "pending"
    belongs_to :user, SurveyEngine.Accounts.User
    belongs_to :lead_form, SurveyEngine.LeadsForms.LeadsForm
    belongs_to :form_group, SurveyEngine.LeadsForms.FormGroup
    has_many :response_items, SurveyEngine.Responses.SurveyResponseItem
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(survey_response, attrs) do
    survey_response
    |> cast(attrs, [
      :date,
      :state,
      :user_id,
      :lead_form_id,
      :data,
      :external_id,
      :form_group_id,
      :review_state
    ])
    |> validate_required([:date, :state, :external_id, :form_group_id])
  end
end
