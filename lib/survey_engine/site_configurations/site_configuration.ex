defmodule SurveyEngine.SiteConfigurations.SiteConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "site_configurations" do
    field :active, :boolean, default: false
    field :name, :string
    field :url, :string
    field :tenant, :string

    has_many :objects, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "site_configurations", behaviour: "object"]

    has_many :alcances, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "site_configurations", behaviour: "alcances"]

    has_many :politicas, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "site_configurations", behaviour: "politicas"]

    has_one :mailer_configuration, SurveyEngine.Mailer.MailerConfiguration
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(site_configuration, attrs) do
    site_configuration
    |> cast(attrs, [:name, :url, :tenant, :active])
    |> validate_required([:name, :url, :tenant, :active])
  end
end
