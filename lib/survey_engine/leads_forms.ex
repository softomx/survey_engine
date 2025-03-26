defmodule SurveyEngine.LeadsForms do
  @moduledoc """
  The LeadsForms context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Repo

  alias SurveyEngine.LeadsForms.LeadsForm

  @doc """
  Returns the list of leads_forms.

  ## Examples

      iex> list_leads_forms()
      [%LeadsForm{}, ...]

  """
  def list_leads_forms do
    Repo.all(LeadsForm)
  end

  def list_leads_forms(args) do
    args
    |> Enum.reduce(LeadsForm, fn
      {:filter, filter}, query ->
        query
        |> filter_leads_form(filter)
    end)
    |> Repo.all()
  end

  def filter_leads_form(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {:form_group_id, form_group_id}, query ->
        from q in query, where: q.form_group_id == ^form_group_id

      {:lang, lang}, query ->
        from q in query, where: q.language == ^lang

      {:form_group_id, form_group_id}, query ->
        from q in query, where: q.form_group_id == ^form_group_id
    end)
  end

  @doc """
  Gets a single leads_form.

  Raises `Ecto.NoResultsError` if the Leads form does not exist.

  ## Examples

      iex> get_leads_form!(123)
      %LeadsForm{}

      iex> get_leads_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leads_form!(id), do: Repo.get!(LeadsForm, id)

  def get_lead_form_by_language_or_default(form_group_id, lang) do
    list = list_leads_forms(%{filter: %{form_group_id: form_group_id}})

    list
    |> Enum.find(&(&1.language == lang))
    |> case do
      nil -> list |> List.first()
      form -> form
    end
  end

  def get_lead_form_by_slug(slug, behaviour, lang) do
    Repo.get_by(LeadsForm, slug: slug, behaviour: behaviour, language: lang)
    |> case do
      nil -> {:error, "lead form not found"}
      form -> {:ok, form}
    end
  end

  def get_lead_form_by_external_id(provider, external_id) do
    Repo.get_by(LeadsForm, provider: provider, external_id: external_id)
    |> case do
      nil -> {:error, "lead form not found"}
      form -> {:ok, form}
    end
  end

  @doc """
  Creates a leads_form.

  ## Examples

      iex> create_leads_form(%{field: value})
      {:ok, %LeadsForm{}}

      iex> create_leads_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leads_form(attrs \\ %{}) do
    %LeadsForm{}
    |> LeadsForm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leads_form.

  ## Examples

      iex> update_leads_form(leads_form, %{field: new_value})
      {:ok, %LeadsForm{}}

      iex> update_leads_form(leads_form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leads_form(%LeadsForm{} = leads_form, attrs) do
    leads_form
    |> LeadsForm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leads_form.

  ## Examples

      iex> delete_leads_form(leads_form)
      {:ok, %LeadsForm{}}

      iex> delete_leads_form(leads_form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leads_form(%LeadsForm{} = leads_form) do
    Repo.delete(leads_form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leads_form changes.

  ## Examples

      iex> change_leads_form(leads_form)
      %Ecto.Changeset{data: %LeadsForm{}}

  """
  def change_leads_form(%LeadsForm{} = leads_form, attrs \\ %{}) do
    LeadsForm.changeset(leads_form, attrs)
  end

  alias SurveyEngine.LeadsForms.FormGroup

  @doc """
  Returns the list of form_groups.

  ## Examples

      iex> list_form_groups()
      [%FormGroup{}, ...]

  """
  def list_form_groups do
    Repo.all(FormGroup)
  end

  @doc """
  Gets a single form_group.

  Raises `Ecto.NoResultsError` if the Form group does not exist.

  ## Examples

      iex> get_form_group!(123)
      %FormGroup{}

      iex> get_form_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_form_group!(id), do: Repo.get!(FormGroup, id)

  @doc """
  Creates a form_group.

  ## Examples

      iex> create_form_group(%{field: value})
      {:ok, %FormGroup{}}

      iex> create_form_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_form_group(attrs \\ %{}) do
    %FormGroup{}
    |> FormGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a form_group.

  ## Examples

      iex> update_form_group(form_group, %{field: new_value})
      {:ok, %FormGroup{}}

      iex> update_form_group(form_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_form_group(%FormGroup{} = form_group, attrs) do
    form_group
    |> FormGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a form_group.

  ## Examples

      iex> delete_form_group(form_group)
      {:ok, %FormGroup{}}

      iex> delete_form_group(form_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_form_group(%FormGroup{} = form_group) do
    Repo.delete(form_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking form_group changes.

  ## Examples

      iex> change_form_group(form_group)
      %Ecto.Changeset{data: %FormGroup{}}

  """
  def change_form_group(%FormGroup{} = form_group, attrs \\ %{}) do
    FormGroup.changeset(form_group, attrs)
  end
end
