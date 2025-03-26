defmodule SurveyEngine.Mailer.Extras do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:api_key, :string)
    field(:secret, :string)
    field(:access_key, :string)
    field(:region, :string)
    field(:domain, :string)
  end

  def changeset(config, attrs) do
    config
    |> cast(attrs, [:api_key, :secret, :access_key, :region, :domain])
    |> validate_adapter_fields(attrs["adapter"])
  end

  defp validate_adapter_fields(changeset, "amazon_ses") do
    changeset
    |> validate_required([:secret, :access_key, :region])
  end

  defp validate_adapter_fields(changeset, "mailgun") do
    changeset
    |> validate_required([:api_key, :domain])
  end

  defp validate_adapter_fields(changeset, "mailjet") do
    changeset
    |> validate_required([:api_key, :secret])
  end

  defp validate_adapter_fields(changeset, "sparkpost") do
    changeset
    |> validate_required([:api_key])
  end

  defp validate_adapter_fields(changeset, _), do: changeset
end
