defmodule SurveyEngine.Translations do
  @moduledoc """
  The Translations context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.Translations.Translation

  @doc """
  Returns the list of translations.

  ## Examples

      iex> list_translations()
      [%Translation{}, ...]

  """
  def list_translations do
    Repo.all(Translation)
  end

  def list_translations(args) do
    args
    |> Enum.reduce(Translation, fn
      {:filter, filter}, query ->
        query |> translations_filter_with(filter)
    end)
    |> Repo.all()
  end

  def translations_filter_with(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {:resource_id, resource_id}, query ->
        from q in query, where: q.resource_id == ^resource_id

      {:type, type}, query ->
        from q in query, where: q.type == ^type

      {:behaviour, behaviour}, query ->
        from q in query, where: q.behaviour == ^behaviour
    end)
  end

  def get_transalation_by_language_or_default(resource_id, type, behaviour, language) do
    translations =
      list_translations(%{filter: %{resource_id: resource_id, type: type, behaviour: behaviour}})

    translations
    |> Enum.find(fn t -> t.language == language end)
    |> case do
      nil ->
        translations
        |> List.first()
        |> case do
          nil ->
            {:error, "translation not found"}

          translation ->
            {:ok, translation}
        end

      translation ->
        {:ok, translation}
    end
  end

  @doc """
  Gets a single translation.

  Raises `Ecto.NoResultsError` if the Translation does not exist.

  ## Examples

      iex> get_translation!(123)
      %Translation{}

      iex> get_translation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_translation!(id), do: Repo.get!(Translation, id)

  @doc """
  Creates a translation.

  ## Examples

      iex> create_translation(%{field: value})
      {:ok, %Translation{}}

      iex> create_translation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translation(attrs \\ %{}) do
    %Translation{}
    |> Translation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a translation.

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

      iex> update_translation(translation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation(%Translation{} = translation, attrs) do
    translation
    |> Translation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a translation.

  ## Examples

      iex> delete_translation(translation)
      {:ok, %Translation{}}

      iex> delete_translation(translation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_translation(%Translation{} = translation) do
    Repo.delete(translation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking translation changes.

  ## Examples

      iex> change_translation(translation)
      %Ecto.Changeset{data: %Translation{}}

  """
  def change_translation(%Translation{} = translation, attrs \\ %{}) do
    Translation.changeset(translation, attrs)
  end
end
