defmodule SurveyEngine.SiteConfigurations.SiteConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "site_configurations" do
    field :active, :boolean, default: false
    field :name, :string
    field :url, :string
    field :tenant, :string
    field :consumer_api_token, :string

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

    embeds_one :extra_config, SurveyEngine.SiteConfigurations.ExtraConfig, on_replace: :delete

    embeds_many :survey_providers, SurveyEngine.SiteConfigurations.SurveyProvider,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(site_configuration, attrs) do
    site_configuration
    |> cast(attrs, [:name, :url, :tenant, :active])
    |> validate_required([:name, :url, :active])
    |> cast_embed(:extra_config)
    |> cast_embed(:survey_providers, sort_param: :providers_sort, drop_param: :providers_drop)
  end
end
