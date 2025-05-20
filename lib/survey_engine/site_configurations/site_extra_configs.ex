defmodule SurveyEngine.SiteConfigurations.ExtraConfig do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:api_key, :string)
    field(:url, :string)
    field(:logo, :string)
  end

  def changeset(config, attrs) do
    config
    |> cast(attrs, [:api_key, :url, :logo])
  end
end
