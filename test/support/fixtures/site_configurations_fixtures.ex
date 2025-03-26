defmodule SurveyEngine.SiteConfigurationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.SiteConfigurations` context.
  """

  @doc """
  Generate a site_configuration.
  """
  def site_configuration_fixture(attrs \\ %{}) do
    {:ok, site_configuration} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        tenant: "some tenant",
        url: "some url"
      })
      |> SurveyEngine.SiteConfigurations.create_site_configuration()

    site_configuration
  end
end
