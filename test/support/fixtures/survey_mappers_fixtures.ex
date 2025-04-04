defmodule SurveyEngine.SurveyMappersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.SurveyMappers` context.
  """

  @doc """
  Generate a survey_mapper.
  """
  def survey_mapper_fixture(attrs \\ %{}) do
    {:ok, survey_mapper} =
      attrs
      |> Enum.into(%{
        field: "some field",
        question_id: "some question_id",
        type: "some type"
      })
      |> SurveyEngine.SurveyMappers.create_survey_mapper()

    survey_mapper
  end
end
