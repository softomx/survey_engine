defmodule SurveyEngine.LeadsForms.FormGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "form_groups" do
    field :name, :string
    has_many :variables, SurveyEngine.LeadsForms.LeadsForm
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(form_group, attrs) do
    form_group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
