defmodule SurveyEngine.ResponsesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.Responses` context.
  """

  @doc """
  Generate a survey_response.
  """
  def survey_response_fixture(attrs \\ %{}) do
    {:ok, survey_response} =
      attrs
      |> Enum.into(%{
        data: %{},
        date: ~D[2025-03-04],
        state: "some state"
      })
      |> SurveyEngine.Responses.create_survey_response()

    survey_response
  end
end
