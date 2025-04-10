defmodule SurveyEngine.FormbricksClient do
  def get_survey(survey_provider_config, id) do
    get_base_url(survey_provider_config)
    |> build_url("/api/v1/management/surveys/#{id}")
    |> make_request(survey_provider_config, :get)
  end

  def get_survey_response(survey_provider_config, id) do
    get_base_url(survey_provider_config)
    |> build_url("/api/v1/management/responses/#{id}")
    |> make_request(survey_provider_config, :get)
  end

  def get_responses_by_survey(survey_provider_config, survey_id) do
    get_base_url(survey_provider_config)
    |> build_url("/api/v1/management/responses?surveyId=#{survey_id}")
    |> make_request(survey_provider_config, :get)
  end

  def get_webhooks(survey_provider_config) do
    get_base_url(survey_provider_config)
    |> build_url("/api/v1/management/webhooks")
    |> make_request(survey_provider_config, :get)
  end

  defp get_base_url(survey_provider_config) do
    survey_provider_config.url
  end

  defp build_url(base_url, path) do
    base_url <> path
  end

  defp make_request(url, survey_provider_config, method, body \\ "") do
    HTTPoison.start()
    headers = ["x-api-key": survey_provider_config.api_key]

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

  def encode_file(file_url, survey_provider_config) do
    case HTTPoison.get(file_url, "x-api-key": survey_provider_config.api_key) do
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
