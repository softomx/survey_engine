defmodule SurveyEngine.SiteConfigurations do
  @moduledoc """
  The SiteConfigurations context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.SiteConfigurations.SiteConfiguration

  @doc """
  Returns the list of site_configurations.

  ## Examples

      iex> list_site_configurations()
      [%SiteConfiguration{}, ...]

  """
  def list_site_configurations do
    Repo.all(SiteConfiguration)
  end

  @doc """
  Gets a single site_configuration.

  Raises `Ecto.NoResultsError` if the Site configuration does not exist.

  ## Examples

      iex> get_site_configuration!(123)
      %SiteConfiguration{}

      iex> get_site_configuration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site_configuration!(id), do: Repo.get!(SiteConfiguration, id)

  def get_site_configuration(id) do
    Repo.get(SiteConfiguration, id)
    |> case do
      nil -> {:error, "site config not found"}
      site_config -> {:ok, site_config}
    end
  end

  def get_site_configuration_by_url(url) do
    Repo.get_by(SiteConfiguration, url: url)
    |> case do
      nil -> {:error, "Site configuration not found"}
      site_config -> {:ok, site_config}
    end
  end

  @doc """
  Creates a site_configuration.

  ## Examples

      iex> create_site_configuration(%{field: value})
      {:ok, %SiteConfiguration{}}

      iex> create_site_configuration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site_configuration(attrs \\ %{}) do
    %SiteConfiguration{}
    |> SiteConfiguration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site_configuration.

  ## Examples

      iex> update_site_configuration(site_configuration, %{field: new_value})
      {:ok, %SiteConfiguration{}}

      iex> update_site_configuration(site_configuration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site_configuration(%SiteConfiguration{} = site_configuration, attrs) do
    site_configuration
    |> SiteConfiguration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site_configuration.

  ## Examples

      iex> delete_site_configuration(site_configuration)
      {:ok, %SiteConfiguration{}}

      iex> delete_site_configuration(site_configuration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site_configuration(%SiteConfiguration{} = site_configuration) do
    Repo.delete(site_configuration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site_configuration changes.

  ## Examples

      iex> change_site_configuration(site_configuration)
      %Ecto.Changeset{data: %SiteConfiguration{}}

  """
  def change_site_configuration(%SiteConfiguration{} = site_configuration, attrs \\ %{}) do
    SiteConfiguration.changeset(site_configuration, attrs)
  end
end
