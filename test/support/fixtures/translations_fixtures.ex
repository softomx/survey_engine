defmodule SurveyEngine.TranslationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.Translations` context.
  """

  @doc """
  Generate a translation.
  """
  def translation_fixture(attrs \\ %{}) do
    {:ok, translation} =
      attrs
      |> Enum.into(%{
        description: "some description",
        type: "some type"
      })
      |> SurveyEngine.Translations.create_translation()

    translation
  end
end
