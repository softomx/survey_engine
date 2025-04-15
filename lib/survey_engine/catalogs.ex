defmodule SurveyEngine.Catalogs do
  @moduledoc """
  The Catalogs context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.Catalogs.Currency

  @doc """
  Returns the list of currencies.

  ## Examples

      iex> list_currencies()
      [%Currency{}, ...]

  """
  def list_currencies do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!(123)
      %Currency{}

      iex> get_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency!(id), do: Repo.get!(Currency, id)

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a currency.

  ## Examples

      iex> update_currency(currency, %{field: new_value})
      {:ok, %Currency{}}

      iex> update_currency(currency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a currency.

  ## Examples

      iex> delete_currency(currency)
      {:ok, %Currency{}}

      iex> delete_currency(currency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency changes.

  ## Examples

      iex> change_currency(currency)
      %Ecto.Changeset{data: %Currency{}}

  """
  def change_currency(%Currency{} = currency, attrs \\ %{}) do
    Currency.changeset(currency, attrs)
  end

  alias SurveyEngine.Catalogs.AgencyType

  @doc """
  Returns the list of agency_types.

  ## Examples

      iex> list_agency_types()
      [%AgencyType{}, ...]

  """
  def list_agency_types do
    Repo.all(AgencyType)
  end

  def list_agency_types_with_preload do
    Repo.all(AgencyType) |> Repo.preload([:descriptions])
  end

  def list_agency_types(args) do
    args
    |> Enum.reduce(AgencyType, fn
      {:filter, filter}, query ->
        query |> agency_types_filter_with(filter)
    end)
    |> Repo.all()
  end

  def agency_types_filter_with(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {:name, name}, query ->
        from q in query, where: q.name == ^name

      {:active, active}, query ->
        from q in query, where: q.active == ^active
    end)
  end

  @doc """
  Gets a single agency_type.

  Raises `Ecto.NoResultsError` if the Agency type does not exist.

  ## Examples

      iex> get_agency_type!(123)
      %AgencyType{}

      iex> get_agency_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agency_type!(id), do: Repo.get!(AgencyType, id)

  @doc """
  Creates a agency_type.

  ## Examples

      iex> create_agency_type(%{field: value})
      {:ok, %AgencyType{}}

      iex> create_agency_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agency_type(attrs \\ %{}) do
    %AgencyType{}
    |> AgencyType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a agency_type.

  ## Examples

      iex> update_agency_type(agency_type, %{field: new_value})
      {:ok, %AgencyType{}}

      iex> update_agency_type(agency_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agency_type(%AgencyType{} = agency_type, attrs) do
    agency_type
    |> AgencyType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a agency_type.

  ## Examples

      iex> delete_agency_type(agency_type)
      {:ok, %AgencyType{}}

      iex> delete_agency_type(agency_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agency_type(%AgencyType{} = agency_type) do
    Repo.delete(agency_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking agency_type changes.

  ## Examples

      iex> change_agency_type(agency_type)
      %Ecto.Changeset{data: %AgencyType{}}

  """
  def change_agency_type(%AgencyType{} = agency_type, attrs \\ %{}) do
    AgencyType.changeset(agency_type, attrs)
  end

  alias SurveyEngine.Catalogs.PersonalTitle

  @doc """
  Returns the list of personal_titles.

  ## Examples

      iex> list_personal_titles()
      [%PersonalTitle{}, ...]

  """
  def list_personal_titles do
    Repo.all(PersonalTitle)
  end

  @doc """
  Gets a single personal_title.

  Raises `Ecto.NoResultsError` if the Personal title does not exist.

  ## Examples

      iex> get_personal_title!(123)
      %PersonalTitle{}

      iex> get_personal_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personal_title!(id), do: Repo.get!(PersonalTitle, id)

  @doc """
  Creates a personal_title.

  ## Examples

      iex> create_personal_title(%{field: value})
      {:ok, %PersonalTitle{}}

      iex> create_personal_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personal_title(attrs \\ %{}) do
    %PersonalTitle{}
    |> PersonalTitle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a personal_title.

  ## Examples

      iex> update_personal_title(personal_title, %{field: new_value})
      {:ok, %PersonalTitle{}}

      iex> update_personal_title(personal_title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personal_title(%PersonalTitle{} = personal_title, attrs) do
    personal_title
    |> PersonalTitle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a personal_title.

  ## Examples

      iex> delete_personal_title(personal_title)
      {:ok, %PersonalTitle{}}

      iex> delete_personal_title(personal_title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personal_title(%PersonalTitle{} = personal_title) do
    Repo.delete(personal_title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personal_title changes.

  ## Examples

      iex> change_personal_title(personal_title)
      %Ecto.Changeset{data: %PersonalTitle{}}

  """
  def change_personal_title(%PersonalTitle{} = personal_title, attrs \\ %{}) do
    PersonalTitle.changeset(personal_title, attrs)
  end

  alias SurveyEngine.Catalogs.AgencyModel

  @doc """
  Returns the list of agency_models.

  ## Examples

      iex> list_agency_models()
      [%AgencyModel{}, ...]

  """
  def list_agency_models do
    Repo.all(AgencyModel)
  end

  @doc """
  Gets a single agency_model.

  Raises `Ecto.NoResultsError` if the Agency model does not exist.

  ## Examples

      iex> get_agency_model!(123)
      %AgencyModel{}

      iex> get_agency_model!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agency_model!(id), do: Repo.get!(AgencyModel, id)

  @doc """
  Creates a agency_model.

  ## Examples

      iex> create_agency_model(%{field: value})
      {:ok, %AgencyModel{}}

      iex> create_agency_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agency_model(attrs \\ %{}) do
    %AgencyModel{}
    |> AgencyModel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a agency_model.

  ## Examples

      iex> update_agency_model(agency_model, %{field: new_value})
      {:ok, %AgencyModel{}}

      iex> update_agency_model(agency_model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agency_model(%AgencyModel{} = agency_model, attrs) do
    agency_model
    |> AgencyModel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a agency_model.

  ## Examples

      iex> delete_agency_model(agency_model)
      {:ok, %AgencyModel{}}

      iex> delete_agency_model(agency_model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agency_model(%AgencyModel{} = agency_model) do
    Repo.delete(agency_model)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking agency_model changes.

  ## Examples

      iex> change_agency_model(agency_model)
      %Ecto.Changeset{data: %AgencyModel{}}

  """
  def change_agency_model(%AgencyModel{} = agency_model, attrs \\ %{}) do
    AgencyModel.changeset(agency_model, attrs)
  end
end
