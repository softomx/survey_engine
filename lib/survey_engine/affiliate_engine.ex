defmodule SurveyEngine.AffiliateEngine do
  @moduledoc """
  The AffiliateEngine context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.AffiliateEngine.Affiliate

  def create_external_affiliate(site_config, %Affiliate{} = affiliate) do
    webhook_config = site_config.extra_config

    affiliate_attrs =
      %{
        name: affiliate.name,
        slug: affiliate.name,
        trading_name: affiliate.trading_name,
        business_name: affiliate.business_name,
        rfc: affiliate.rfc,
        agency_type: "credito",
        company_type: affiliate.company_type,
        fiscal_address: %{
          street: "street name",
          external_number: "external_number",
          neighborhood: "neighborhood",
          country: "country",
          postal_code: "postal_code",
          location: "0"
        }
      }
      |> IO.inspect()

    with {:ok, response} <-
           SurveyEngine.ReservatorClient.create_external_affiliate(
             webhook_config.url,
             affiliate_attrs,
             [
               {"Authorization", webhook_config.api_key}
             ]
           ) do
    end
    |> IO.inspect()
  end

  @doc """
  Returns the list of affiliates.

  ## Examples

      iex> list_affiliates()
      [%Affiliate{}, ...]

  """
  def list_affiliates do
    Repo.all(Affiliate)
  end

  @doc """
  Gets a single affiliate.

  Raises `Ecto.NoResultsError` if the Affiliate does not exist.

  ## Examples

      iex> get_affiliate!(123)
      %Affiliate{}

      iex> get_affiliate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_affiliate!(id), do: Repo.get!(Affiliate, id)

  @doc """
  Creates a affiliate.

  ## Examples

      iex> create_affiliate(%{field: value})
      {:ok, %Affiliate{}}

      iex> create_affiliate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_affiliate(attrs \\ %{}) do
    %Affiliate{}
    |> Affiliate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a affiliate.

  ## Examples

      iex> update_affiliate(affiliate, %{field: new_value})
      {:ok, %Affiliate{}}

      iex> update_affiliate(affiliate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_affiliate(%Affiliate{} = affiliate, attrs) do
    affiliate
    |> Affiliate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a affiliate.

  ## Examples

      iex> delete_affiliate(affiliate)
      {:ok, %Affiliate{}}

      iex> delete_affiliate(affiliate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_affiliate(%Affiliate{} = affiliate) do
    Repo.delete(affiliate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking affiliate changes.

  ## Examples

      iex> change_affiliate(affiliate)
      %Ecto.Changeset{data: %Affiliate{}}

  """
  def change_affiliate(%Affiliate{} = affiliate, attrs \\ %{}) do
    Affiliate.changeset(affiliate, attrs)
  end
end
