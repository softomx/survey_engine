defmodule SurveyEngine.Companies.CompanyLink do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :type, :string
    field :url, :string
  end

  def changeset(to, attrs) do
    to
    |> cast(attrs, [:type, :url])
    |> validate_required([:type, :url])
  end
end
