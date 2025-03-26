defmodule SurveyEngine.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        agency_name: "some agency_name",
        agency_type: "some agency_type",
        billing_currency: "some billing_currency",
        city: "some city",
        country: "some country",
        date: "some date",
        language: "some language",
        legal_name: "some legal_name",
        rfc: "some rfc",
        town: "some town"
      })
      |> SurveyEngine.Companies.create_company()

    company
  end
end
