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
    |> validate_url(:url)
  end

  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          SurveyEngine.TransaleteHelper.changeset_error(:invalid_url_scheme)

        %URI{host: nil} ->
          SurveyEngine.TransaleteHelper.changeset_error(:invalid_url_host)

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} ->
              nil

            {:error, _} ->
              SurveyEngine.TransaleteHelper.changeset_error(:invalid_url_host)
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end
end
