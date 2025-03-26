defmodule SurveyEngine.BusinessModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.BusinessModels` context.
  """

  @doc """
  Generate a business_model.
  """
  def business_model_fixture(attrs \\ %{}) do
    {:ok, business_model} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some slug"
      })
      |> SurveyEngine.BusinessModels.create_business_model()

    business_model
  end

  @doc """
  Generate a business_config.
  """
  def business_config_fixture(attrs \\ %{}) do
    {:ok, business_config} =
      attrs
      |> Enum.into(%{
        order: 42,
        previous_lead_form_finished: [],
        required: true
      })
      |> SurveyEngine.BusinessModels.create_business_config()

    business_config
  end
end
