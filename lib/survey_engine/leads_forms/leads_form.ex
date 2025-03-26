defmodule SurveyEngine.LeadsForms.LeadsForm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leads_forms" do
    field :active, :boolean, default: false
    field :name, :string
    field :language, :string
    field :external_id, :string
    field :behaviour, :string, default: "affiliate_register"
    field :slug, :string
    field :provider, :string, default: "formbricks"
    belongs_to :form_group, SurveyEngine.FormGroups.FormGroup
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(leads_form, attrs) do
    leads_form
    |> cast(attrs, [
      :name,
      :language,
      :external_id,
      :active,
      :slug,
      :behaviour,
      :provider,
      :form_group_id
    ])
    |> validate_required([:name, :language, :external_id, :active, :behaviour])
  end
end
