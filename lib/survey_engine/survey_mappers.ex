defmodule SurveyEngine.SurveyMappers do
  @moduledoc """
  The SurveyMappers context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.SurveyMappers.SurveyMapper

  def get_fields_of_schema(schema) do
    schema.__schema__(:fields)
    |> Enum.map(fn
      field ->
        schema.__schema__(:type, field)
        |> case do
          {:parameterized, {_, %{related: related}}} ->
            %{field: field, deps: get_fields_of_schema(related)}

          _ ->
            %{field: field, deps: []}
        end
    end)
  end

  @doc """
  Returns the list of survey_mapper.

  ## Examples

      iex> list_survey_mapper()
      [%SurveyMapper{}, ...]

  """
  def list_survey_mapper do
    Repo.all(SurveyMapper)
  end

  @doc """
  Gets a single survey_mapper.

  Raises `Ecto.NoResultsError` if the Survey mapper does not exist.

  ## Examples

      iex> get_survey_mapper!(123)
      %SurveyMapper{}

      iex> get_survey_mapper!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_mapper!(id), do: Repo.get!(SurveyMapper, id)

  @doc """
  Creates a survey_mapper.

  ## Examples

      iex> create_survey_mapper(%{field: value})
      {:ok, %SurveyMapper{}}

      iex> create_survey_mapper(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_mapper(attrs \\ %{}) do
    %SurveyMapper{}
    |> SurveyMapper.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_mapper.

  ## Examples

      iex> update_survey_mapper(survey_mapper, %{field: new_value})
      {:ok, %SurveyMapper{}}

      iex> update_survey_mapper(survey_mapper, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_mapper(%SurveyMapper{} = survey_mapper, attrs) do
    survey_mapper
    |> SurveyMapper.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survey_mapper.

  ## Examples

      iex> delete_survey_mapper(survey_mapper)
      {:ok, %SurveyMapper{}}

      iex> delete_survey_mapper(survey_mapper)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_mapper(%SurveyMapper{} = survey_mapper) do
    Repo.delete(survey_mapper)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_mapper changes.

  ## Examples

      iex> change_survey_mapper(survey_mapper)
      %Ecto.Changeset{data: %SurveyMapper{}}

  """
  def change_survey_mapper(%SurveyMapper{} = survey_mapper, attrs \\ %{}) do
    SurveyMapper.changeset(survey_mapper, attrs)
  end
end
