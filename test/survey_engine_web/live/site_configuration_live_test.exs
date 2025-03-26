defmodule SurveyEngineWeb.SiteConfigurationLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.SiteConfigurationsFixtures

  @create_attrs %{active: true, name: "some name", url: "some url", tenant: "some tenant"}
  @update_attrs %{
    active: false,
    name: "some updated name",
    url: "some updated url",
    tenant: "some updated tenant"
  }
  @invalid_attrs %{active: false, name: nil, url: nil, tenant: nil}

  defp create_site_configuration(_) do
    site_configuration = site_configuration_fixture()
    %{site_configuration: site_configuration}
  end

  describe "Index" do
    setup [:create_site_configuration]

    test "lists all site_configurations", %{conn: conn, site_configuration: site_configuration} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/site_configurations")

      assert html =~ "Listing Site configurations"
      assert html =~ site_configuration.name
    end

    test "saves new site_configuration", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/site_configurations")

      assert index_live |> element("a", "New Site configuration") |> render_click() =~
               "New Site configuration"

      assert_patch(index_live, ~p"/admin/site_configurations/new")

      assert index_live
             |> form("#site_configuration-form", site_configuration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site_configuration-form", site_configuration: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/site_configurations")

      html = render(index_live)
      assert html =~ "Site configuration created successfully"
      assert html =~ "some name"
    end

    test "updates site_configuration in listing", %{
      conn: conn,
      site_configuration: site_configuration
    } do
      {:ok, index_live, _html} = live(conn, ~p"/admin/site_configurations")

      assert index_live
             |> element("#site_configurations-#{site_configuration.id} a", "Edit")
             |> render_click() =~
               "Edit Site configuration"

      assert_patch(index_live, ~p"/admin/site_configurations/#{site_configuration}/edit")

      assert index_live
             |> form("#site_configuration-form", site_configuration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site_configuration-form", site_configuration: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/site_configurations")

      html = render(index_live)
      assert html =~ "Site configuration updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes site_configuration in listing", %{
      conn: conn,
      site_configuration: site_configuration
    } do
      {:ok, index_live, _html} = live(conn, ~p"/admin/site_configurations")

      assert index_live
             |> element("#site_configurations-#{site_configuration.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#site_configurations-#{site_configuration.id}")
    end
  end

  describe "Show" do
    setup [:create_site_configuration]

    test "displays site_configuration", %{conn: conn, site_configuration: site_configuration} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/site_configurations/#{site_configuration}")

      assert html =~ "Show Site configuration"
      assert html =~ site_configuration.name
    end

    test "updates site_configuration within modal", %{
      conn: conn,
      site_configuration: site_configuration
    } do
      {:ok, show_live, _html} = live(conn, ~p"/admin/site_configurations/#{site_configuration}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site configuration"

      assert_patch(show_live, ~p"/admin/site_configurations/#{site_configuration}/show/edit")

      assert show_live
             |> form("#site_configuration-form", site_configuration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#site_configuration-form", site_configuration: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/site_configurations/#{site_configuration}")

      html = render(show_live)
      assert html =~ "Site configuration updated successfully"
      assert html =~ "some updated name"
    end
  end
end
