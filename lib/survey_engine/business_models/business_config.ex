defmodule SurveyEngine.BusinessModels.BusinessConfig do
  use Ecto.Schema
  import Ecto.Changeset

  schema "business_configs" do
    field :required, :boolean, default: false
    field :order, :integer
    field :previous_lead_form_finished, {:array, :id}, default: []
    belongs_to :form_group, SurveyEngine.LeadsForms.FormGroup
    belongs_to :business_model, SurveyEngine.BusinessModels.BusinessModel
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(business_config, attrs) do
    business_config
    |> cast(attrs, [
      :order,
      :required,
      :previous_lead_form_finished,
      :business_model_id,
      :form_group_id
    ])
    |> validate_required([
      :order,
      :required,
      :business_model_id,
      :form_group_id
    ])
  end
end
