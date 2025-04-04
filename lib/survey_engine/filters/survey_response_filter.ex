defmodule SurveyEngine.Filters.SurveyResponseFilter do
  use Ecto.Schema
  import Ecto.Changeset
  alias SurveyEngine.Filters.PreRegistrationFilter

  embedded_schema do
    field :states, {:array, :string}
    field :form_group_id, :id
    embeds_one :company_filter, PreRegistrationFilter
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [
      :states,
      :form_group_id
    ])
    |> cast_embed(:company_filter, with: &PreRegistrationFilter.changeset/2)
  end
end
