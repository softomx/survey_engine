defmodule SurveyEngine.SiteConfigurationsTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.SiteConfigurations

  describe "site_configurations" do
    alias SurveyEngine.SiteConfigurations.SiteConfiguration

    import SurveyEngine.SiteConfigurationsFixtures

    @invalid_attrs %{active: nil, name: nil, url: nil, tenant: nil}

    test "list_site_configurations/0 returns all site_configurations" do
      site_configuration = site_configuration_fixture()
      assert SiteConfigurations.list_site_configurations() == [site_configuration]
    end

    test "get_site_configuration!/1 returns the site_configuration with given id" do
      site_configuration = site_configuration_fixture()
      assert SiteConfigurations.get_site_configuration!(site_configuration.id) == site_configuration
    end

    test "create_site_configuration/1 with valid data creates a site_configuration" do
      valid_attrs = %{active: true, name: "some name", url: "some url", tenant: "some tenant"}

      assert {:ok, %SiteConfiguration{} = site_configuration} = SiteConfigurations.create_site_configuration(valid_attrs)
      assert site_configuration.active == true
      assert site_configuration.name == "some name"
      assert site_configuration.url == "some url"
      assert site_configuration.tenant == "some tenant"
    end

    test "create_site_configuration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SiteConfigurations.create_site_configuration(@invalid_attrs)
    end

    test "update_site_configuration/2 with valid data updates the site_configuration" do
      site_configuration = site_configuration_fixture()
      update_attrs = %{active: false, name: "some updated name", url: "some updated url", tenant: "some updated tenant"}

      assert {:ok, %SiteConfiguration{} = site_configuration} = SiteConfigurations.update_site_configuration(site_configuration, update_attrs)
      assert site_configuration.active == false
      assert site_configuration.name == "some updated name"
      assert site_configuration.url == "some updated url"
      assert site_configuration.tenant == "some updated tenant"
    end

    test "update_site_configuration/2 with invalid data returns error changeset" do
      site_configuration = site_configuration_fixture()
      assert {:error, %Ecto.Changeset{}} = SiteConfigurations.update_site_configuration(site_configuration, @invalid_attrs)
      assert site_configuration == SiteConfigurations.get_site_configuration!(site_configuration.id)
    end

    test "delete_site_configuration/1 deletes the site_configuration" do
      site_configuration = site_configuration_fixture()
      assert {:ok, %SiteConfiguration{}} = SiteConfigurations.delete_site_configuration(site_configuration)
      assert_raise Ecto.NoResultsError, fn -> SiteConfigurations.get_site_configuration!(site_configuration.id) end
    end

    test "change_site_configuration/1 returns a site_configuration changeset" do
      site_configuration = site_configuration_fixture()
      assert %Ecto.Changeset{} = SiteConfigurations.change_site_configuration(site_configuration)
    end
  end
end
