defmodule SurveyEngine.AffiliateEngineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.AffiliateEngine` context.
  """

  @doc """
  Generate a affiliate.
  """
  def affiliate_fixture(attrs \\ %{}) do
    {:ok, affiliate} =
      attrs
      |> Enum.into(%{
        affiliate_slug: "some affiliate_slug",
        business_name: "some business_name",
        company_type: "some company_type",
        name: "some name",
        rfc: "some rfc",
        trading_name: "some trading_name"
      })
      |> SurveyEngine.AffiliateEngine.create_affiliate()

    affiliate
  end
end
