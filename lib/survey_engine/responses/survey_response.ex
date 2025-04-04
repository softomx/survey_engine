defmodule SurveyEngine.Responses.SurveyResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_responses" do
    field :data, :map
    field :date, :date
    field :state, :string
    #field :user_id, :id
    field :external_id, :string
    belongs_to :user, SurveyEngine.Accounts.User
    belongs_to :lead_form, SurveyEngine.LeadsForms.LeadsForm
    belongs_to :form_group, SurveyEngine.LeadsForms.FormGroup
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(survey_response, attrs) do
    survey_response
    |> cast(attrs, [:date, :state, :user_id, :lead_form_id, :data, :external_id, :form_group_id])
    |> validate_required([:date, :state, :external_id, :form_group_id])
  end
end
