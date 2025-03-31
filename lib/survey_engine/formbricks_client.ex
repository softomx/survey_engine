defmodule SurveyEngine.FormbricksClient do
  def get_survey(id) do
    get_base_url()
    |> build_url("/api/v1/management/surveys/#{id}")
    |> make_request(:get)
  end

  def get_survey_response(id) do
    get_base_url()
    |> build_url("/api/v1/management/responses/#{id}")
    |> make_request(:get)
  end

  def get_responses_by_survey(survey_id) do
    get_base_url()
    |> build_url("/api/v1/management/responses?surveyId=#{survey_id}")
    |> make_request(:get)
  end

  def get_webhooks() do
    get_base_url()
    |> build_url("/api/v1/management/webhooks")
    |> make_request(:get)
  end

  defp get_base_url() do
    "https://form-surveys-formbricks-app.mbf3gu.easypanel.host"
  end

  defp build_url(base_url, path) do
    base_url <> path
  end

  defp make_request(url, method, body \\ "") do
    HTTPoison.start()
    headers = ["x-api-key": "5a59e36304167ea0257cf1ac0b8e8252"]

    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Jason.decode!(body)

        case response do
          %{"code" => _, "message" => _} -> {:error, response}
          _ -> {:ok, response}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, "Unauthorized"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        {:error, "Internal server error"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def encode_file(file_url) do
    case HTTPoison.get(file_url, "x-api-key": "5a59e36304167ea0257cf1ac0b8e8252") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Base.encode64(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, "Unauthorized"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        {:error, "Internal server error"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
