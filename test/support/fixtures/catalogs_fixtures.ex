defmodule SurveyEngine.CatalogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.Catalogs` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        slug: "some slug"
      })
      |> SurveyEngine.Catalogs.create_currency()

    currency
  end

  @doc """
  Generate a agency_type.
  """
  def agency_type_fixture(attrs \\ %{}) do
    {:ok, agency_type} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name"
      })
      |> SurveyEngine.Catalogs.create_agency_type()

    agency_type
  end

  @doc """
  Generate a personal_title.
  """
  def personal_title_fixture(attrs \\ %{}) do
    {:ok, personal_title} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SurveyEngine.Catalogs.create_personal_title()

    personal_title
  end

  @doc """
  Generate a agency_model.
  """
  def agency_model_fixture(attrs \\ %{}) do
    {:ok, agency_model} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SurveyEngine.Catalogs.create_agency_model()

    agency_model
  end
end
