defmodule SurveyEngine.Mailer.MailerConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mailer_configurations" do
    field(:name, :string)
    embeds_one(:configuration, SurveyEngine.Mailer.Extras, on_replace: :update)
    field(:email_from, :string)
    field(:email_name, :string)
    field(:adapter, :string)
    belongs_to :site_configuration, SurveyEngine.SiteConfigurations.SiteConfiguration
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:adapter, :email_from, :email_name, :name, :site_configuration_id])
    |> validate_required([:adapter, :email_from, :email_name, :name, :site_configuration_id])
    |> cast_embed(:configuration, with: &SurveyEngine.Mailer.Extras.changeset/2)
    |> validate_format(:email_from, ~r/^[^\s]+@[^\s]+$/,
      message: "must have the @ sign and no spaces"
    )
  end
end
