defmodule SurveyEngine.Responses do
  @moduledoc """
  The Responses context.
  """

  import Ecto.Query, warn: false
  alias SurveyEngine.Companies
  alias SurveyEngine.Companies.Company
  alias SurveyEngine.Accounts.User
  alias SurveyEngine.LeadsForms.LeadsForm
  alias SurveyEngine.LeadsForms.FormGroup
  alias SurveyEngine.Repo

  alias SurveyEngine.Responses.SurveyResponse
  alias SurveyEngine.Responses.SurveyResponseItem

  @doc """
  Returns the list of survey_responses.

  ## Examples

      iex> list_survey_responses()
      [%SurveyResponse{}, ...]

  """
  def list_survey_responses do
    Repo.all(SurveyResponse)
  end

  def list_survey_responses_with_preloads(responses) do
    responses |> Repo.preload([:lead_form, :form_group, :user])
  end

  def list_survey_resposes(args) do
    args
    |> Enum.reduce(SurveyResponse, fn
      {:filter, filter}, query ->
        query
        |> filter_survey_response(filter)
    end)
    |> Repo.all()
  end

  def survey_resposes_with_preloads(survey_resposes, preloads) do
    survey_resposes
    |> Repo.preload(preloads)
  end

  def filter_survey_response(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {_key, nil}, query ->
        query

      {:user_id, user_id}, query ->
        from q in query, where: q.user_id == ^user_id

      {:form_group_id, form_group_id}, query ->
        from q in query,
          join: lf in LeadsForm,
          on: q.lead_form_id == lf.id,
          join: f in FormGroup,
          on: lf.form_group_id == f.id,
          where: f.id == ^form_group_id

      {:lang, lang}, query ->
        from q in query, where: q.lang == ^lang

      {:state, state}, query ->
        from q in query, where: q.state == ^state

      {:states, states}, query ->
        from q in query, where: q.state in ^states

      {:company_filter, company_filter}, query ->
        query_company = Companies.companies_filter(Company, company_filter)

        from q in query,
          join: u in User,
          on: q.user_id == u.id,
          join: c in ^query_company,
          on: u.company_id == c.id

      {:review_state, review_state}, query ->
        from q in query, where: q.review_state == ^review_state

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single survey_response.

  Raises `Ecto.NoResultsError` if the Survey response does not exist.

  ## Examples

      iex> get_survey_response!(123)
      %SurveyResponse{}

      iex> get_survey_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_response!(id),
    do: Repo.get!(SurveyResponse, id) |> Repo.preload([:response_items])

  def get_survey_response(id) do
    Repo.get(SurveyResponse, id)
    |> case do
      nil -> {:error, "SurveyResponse notfound"}
      survey_response -> {:ok, survey_response}
    end
  end

  def get_survey_response_by_external_id(user_id, lead_form_id) do
    Repo.get_by(SurveyResponse,
      user_id: user_id,
      lead_form_id: lead_form_id
    )
    |> Repo.preload([:response_items])
  end

  def get_last_response(form_group_id, user_id) do
    list_survey_resposes(%{
      filter: %{user_id: user_id, form_group_id: form_group_id}
    })
    |> List.last()
    |> Repo.preload([:response_items])
  end

  def get_survey_response_with_preloads(id, preloads) do
    get_survey_response(id)
    |> case do
      {:ok, survey_response} -> {:ok, survey_response |> Repo.preload(preloads)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Creates a survey_response.

  ## Examples

      iex> create_survey_response(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_response(attrs \\ %{}) do
    %SurveyResponse{}
    |> SurveyResponse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_response.

  ## Examples

      iex> update_survey_response(survey_response, %{field: new_value})
      {:ok, %SurveyResponse{}}

      iex> update_survey_response(survey_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_response(%SurveyResponse{} = survey_response, attrs) do
    survey_response
    |> SurveyResponse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survey_response.

  ## Examples

      iex> delete_survey_response(survey_response)
      {:ok, %SurveyResponse{}}

      iex> delete_survey_response(survey_response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_response(%SurveyResponse{} = survey_response) do
    Repo.delete(survey_response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_response changes.

  ## Examples

      iex> change_survey_response(survey_response)
      %Ecto.Changeset{data: %SurveyResponse{}}

  """
  def change_survey_response(%SurveyResponse{} = survey_response, attrs \\ %{}) do
    SurveyResponse.changeset(survey_response, attrs)
  end

  @doc """
  Creates a survey_response_item.

  ## Examples

      iex> create_survey_response_item(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_response_item(attrs \\ %{}) do
    %SurveyResponseItem{}
    |> SurveyResponseItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_response_item.

  ## Examples

      iex> update_survey_response_item(survey_response_item, %{field: new_value})
      {:ok, %SurveyResponseItem{}}

      iex> update_survey_response_item(survey_response_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_response_item(%SurveyResponseItem{} = survey_response_item, attrs) do
    survey_response_item
    |> SurveyResponseItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survey_response_item.

  ## Examples

      iex> delete_survey_response_item(survey_response_item)
      {:ok, %SurveyResponseItem{}}

      iex> delete_survey_response_item(survey_response_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_response_item(%SurveyResponseItem{} = survey_response_item) do
    Repo.delete(survey_response_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_response_item changes.

  ## Examples

      iex> change_survey_response_item(survey_response_item)
      %Ecto.Changeset{data: %SurveyResponseItem{}}

  """
  def change_survey_response_item(%SurveyResponseItem{} = survey_response_item, attrs \\ %{}) do
    SurveyResponseItem.changeset(survey_response_item, attrs)
  end
end
