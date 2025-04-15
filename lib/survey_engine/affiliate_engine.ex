defmodule SurveyEngine.AffiliateEngine do
  @moduledoc """
  The AffiliateEngine context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.AffiliateEngine
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
        agency_type: affiliate.agency_model,
        company_type: affiliate.agency_type,
        base_currency: affiliate.base_currency,
        fiscal_address: %{
          street: affiliate.address.street,
          internal_number: affiliate.address.internal_number,
          external_number: affiliate.address.external_number,
          neighborhood: affiliate.address.neighborhood,
          country: affiliate.address.country,
          postal_code: affiliate.address.postal_code,
          location: "0"
        }
      }

    with {:ok, response} <-
           SurveyEngine.ReservatorClient.create_external_affiliate(
             webhook_config.url,
             affiliate_attrs,
             [
               {"Authorization", webhook_config.api_key}
             ]
           )
           |> IO.inspect() do
      {:ok, response}
    end
  end

  @spec list_affiliates() :: any()
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
