defmodule SurveyEngineWeb.AgencyTypeLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.CatalogsFixtures

  @create_attrs %{active: true, name: "some name"}
  @update_attrs %{active: false, name: "some updated name"}
  @invalid_attrs %{active: false, name: nil}

  defp create_agency_type(_) do
    agency_type = agency_type_fixture()
    %{agency_type: agency_type}
  end

  describe "Index" do
    setup [:create_agency_type]

    test "lists all agency_types", %{conn: conn, agency_type: agency_type} do
      {:ok, _index_live, html} = live(conn, ~p"/agency_types")

      assert html =~ "Listing Agency types"
      assert html =~ agency_type.name
    end

    test "saves new agency_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/agency_types")

      assert index_live |> element("a", "New Agency type") |> render_click() =~
               "New Agency type"

      assert_patch(index_live, ~p"/agency_types/new")

      assert index_live
             |> form("#agency_type-form", agency_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#agency_type-form", agency_type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/agency_types")

      html = render(index_live)
      assert html =~ "Agency type created successfully"
      assert html =~ "some name"
    end

    test "updates agency_type in listing", %{conn: conn, agency_type: agency_type} do
      {:ok, index_live, _html} = live(conn, ~p"/agency_types")

      assert index_live |> element("#agency_types-#{agency_type.id} a", "Edit") |> render_click() =~
               "Edit Agency type"

      assert_patch(index_live, ~p"/agency_types/#{agency_type}/edit")

      assert index_live
             |> form("#agency_type-form", agency_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#agency_type-form", agency_type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/agency_types")

      html = render(index_live)
      assert html =~ "Agency type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes agency_type in listing", %{conn: conn, agency_type: agency_type} do
      {:ok, index_live, _html} = live(conn, ~p"/agency_types")

      assert index_live |> element("#agency_types-#{agency_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#agency_types-#{agency_type.id}")
    end
  end

  describe "Show" do
    setup [:create_agency_type]

    test "displays agency_type", %{conn: conn, agency_type: agency_type} do
      {:ok, _show_live, html} = live(conn, ~p"/agency_types/#{agency_type}")

      assert html =~ "Show Agency type"
      assert html =~ agency_type.name
    end

    test "updates agency_type within modal", %{conn: conn, agency_type: agency_type} do
      {:ok, show_live, _html} = live(conn, ~p"/agency_types/#{agency_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Agency type"

      assert_patch(show_live, ~p"/agency_types/#{agency_type}/show/edit")

      assert show_live
             |> form("#agency_type-form", agency_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#agency_type-form", agency_type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/agency_types/#{agency_type}")

      html = render(show_live)
      assert html =~ "Agency type updated successfully"
      assert html =~ "some updated name"
    end
  end
end
