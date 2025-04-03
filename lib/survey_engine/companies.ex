defmodule SurveyEngine.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.Companies.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  def list_companies_with_preloads(companies) do
    companies |> Repo.preload([:business_model])
  end

  def list_companies(args) do
    args
    |> Enum.reduce(Company, fn
      {:filter, filter}, query ->
        query |> companies_filter(filter)
    end)
    |> Repo.all()
  end

  def companies_filter(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {_key, nil}, query ->
        query
      {:agency_name, agency_name}, query ->
        from q in query, where: ilike(q.agency_name, ^"%#{agency_name}%")

      {:languages, languages}, query ->
        from q in query, where: q.language in ^languages

      {:status, status}, query ->
        from q in query, where: q.status in ^status

      {:business_models, business_models}, query ->
        from q in query, where: q.business_model_id in ^business_models

      {:agency_types, agency_types}, query ->
        from q in query, where: q.agency_type in ^agency_types

      {:countries, countries}, query ->
        from q in query, where: q.country in ^countries

      {:towns, towns}, query ->
        from q in query, where: q.town in ^towns

      {:register_dates, register_dates}, query ->
        start_date =
        register_dates.start_date
          |> Timex.to_datetime("America/Cancun")
          |> Timex.to_datetime("Etc/UTC")

        end_date =
        register_dates.end_date
          |> Timex.to_datetime("America/Cancun")
          |> Timex.end_of_day()
          |> Timex.to_datetime("Etc/UTC")

          from(q in query, where: q.inserted_at >= ^start_date and q.inserted_at <= ^end_date)
      _, query ->
        query
    end)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Form registration does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  def get_company(id) do
    Repo.get(Company, id)
    |> case do
      nil -> {:error, "register notfound"}
      register -> {:ok, register}
    end
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  def get_agency_types() do
    query =
      from q in Company,
        select: q.agency_type,
        distinct: q.agency_type,
        where: not is_nil(q.agency_type)

    Repo.all(query)
  end

  def get_countries() do
    query =
      from q in Company,
        select: q.country,
        distinct: q.country,
        where: not is_nil(q.country)

    Repo.all(query)
  end

  def get_towns() do
    query =
      from q in Company,
        select: q.town,
        distinct: q.town,
        where: not is_nil(q.town)

    Repo.all(query)
  end
end
