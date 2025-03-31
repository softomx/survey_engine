defmodule SurveyEngine.BusinessModels do
  @moduledoc """
  The BusinessModels context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.BusinessModels.BusinessModel

  @doc """
  Returns the list of business_models.

  ## Examples

      iex> list_business_models()
      [%BusinessModel{}, ...]

  """
  def list_business_models do
    Repo.all(BusinessModel)
  end

  @doc """
  Gets a single business_model.

  Raises `Ecto.NoResultsError` if the Business model does not exist.

  ## Examples

      iex> get_business_model!(123)
      %BusinessModel{}

      iex> get_business_model!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business_model!(id), do: Repo.get!(BusinessModel, id)

  @doc """
  Creates a business_model.

  ## Examples

      iex> create_business_model(%{field: value})
      {:ok, %BusinessModel{}}

      iex> create_business_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_business_model(attrs \\ %{}) do
    %BusinessModel{}
    |> BusinessModel.changeset(attrs)
    |> Repo.insert()
  end

  def preload_assocs(query, preloads) do
    Repo.preload(query, preloads)
  end

  @doc """
  Updates a business_model.

  ## Examples

      iex> update_business_model(business_model, %{field: new_value})
      {:ok, %BusinessModel{}}

      iex> update_business_model(business_model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business_model(%BusinessModel{} = business_model, attrs) do
    business_model
    |> BusinessModel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a business_model.

  ## Examples

      iex> delete_business_model(business_model)
      {:ok, %BusinessModel{}}

      iex> delete_business_model(business_model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business_model(%BusinessModel{} = business_model) do
    Repo.delete(business_model)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_model changes.

  ## Examples

      iex> change_business_model(business_model)
      %Ecto.Changeset{data: %BusinessModel{}}

  """
  def change_business_model(%BusinessModel{} = business_model, attrs \\ %{}) do
    BusinessModel.changeset(business_model, attrs)
  end

  alias SurveyEngine.BusinessModels.BusinessConfig

  @doc """
  Returns the list of business_configs.

  ## Examples

      iex> list_business_configs()
      [%BusinessConfig{}, ...]

  """
  def list_business_configs do
    Repo.all(BusinessConfig)
  end

  def list_business_configs(args) do
    args
    |> Enum.reduce(BusinessConfig, fn
      {:filter, filter}, query ->
        query |> business_configs_filter(filter)
    end)
    |> Repo.all()
  end

  def business_configs_filter(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {:business_model_id, business_model_id}, query ->
        from q in query, where: q.business_model_id == ^business_model_id

      {:ids, ids}, query ->
        from q in query, where: q.id in ^ids
    end)
  end

  @doc """
  Gets a single business_config.

  Raises `Ecto.NoResultsError` if the Business config does not exist.

  ## Examples

      iex> get_business_config!(123)
      %BusinessConfig{}

      iex> get_business_config!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business_config!(id), do: Repo.get!(BusinessConfig, id)

  @doc """
  Creates a business_config.

  ## Examples

      iex> create_business_config(%{field: value})
      {:ok, %BusinessConfig{}}

      iex> create_business_config(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_business_config(attrs \\ %{}) do
    %BusinessConfig{}
    |> BusinessConfig.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a business_config.

  ## Examples

      iex> update_business_config(business_config, %{field: new_value})
      {:ok, %BusinessConfig{}}

      iex> update_business_config(business_config, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business_config(%BusinessConfig{} = business_config, attrs) do
    business_config
    |> BusinessConfig.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a business_config.

  ## Examples

      iex> delete_business_config(business_config)
      {:ok, %BusinessConfig{}}

      iex> delete_business_config(business_config)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business_config(%BusinessConfig{} = business_config) do
    Repo.delete(business_config)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_config changes.

  ## Examples

      iex> change_business_config(business_config)
      %Ecto.Changeset{data: %BusinessConfig{}}

  """
  def change_business_config(%BusinessConfig{} = business_config, attrs \\ %{}) do
    BusinessConfig.changeset(business_config, attrs)
  end
end
