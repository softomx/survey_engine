defmodule SurveyEngine.ReservatorClient do
  @headers ["Content-Type": "application/json"]

  def create_external_affiliate(url, attrs, headers) do
    HTTPoison.post(url, attrs |> Jason.encode!(), @headers ++ headers)
  end

  def process_response(response) do
    response
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Error: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error: #{reason}"}
    end
  end
end
