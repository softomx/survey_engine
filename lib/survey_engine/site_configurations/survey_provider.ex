defmodule SurveyEngine.SiteConfigurations.SurveyProvider do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :provider, :string
    field(:url, :string)
    field(:api_key, :string)
  end

  def changeset(config, attrs) do
    config
    |> cast(attrs, [:api_key, :url, :provider])
  end
end
