defmodule SurveyEngineWeb.AgencyModelLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.CatalogsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_agency_model(_) do
    agency_model = agency_model_fixture()
    %{agency_model: agency_model}
  end

  describe "Index" do
    setup [:create_agency_model]

    test "lists all agency_models", %{conn: conn, agency_model: agency_model} do
      {:ok, _index_live, html} = live(conn, ~p"/catalogs/agency_models")

      assert html =~ "Listing Agency models"
      assert html =~ agency_model.name
    end

    test "saves new agency_model", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/catalogs/agency_models")

      assert index_live |> element("a", "New Agency model") |> render_click() =~
               "New Agency model"

      assert_patch(index_live, ~p"/catalogs/agency_models/new")

      assert index_live
             |> form("#agency_model-form", agency_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#agency_model-form", agency_model: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/catalogs/agency_models")

      assert html =~ "Agency model created successfully"
      assert html =~ "some name"
    end

    test "updates agency_model in listing", %{conn: conn, agency_model: agency_model} do
      {:ok, index_live, _html} = live(conn, ~p"/catalogs/agency_models")

      assert index_live
             |> element("a[href='/agency_models/#{agency_model.id}/edit']", "Edit")
             |> render_click() =~
               "Edit Agency model"

      assert_patch(index_live, ~p"/catalogs/agency_models/#{agency_model}/edit")

      assert index_live
             |> form("#agency_model-form", agency_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#agency_model-form", agency_model: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/catalogs/agency_models")

      assert html =~ "Agency model updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes agency_model in listing", %{conn: conn, agency_model: agency_model} do
      {:ok, index_live, _html} = live(conn, ~p"/catalogs/agency_models")

      assert index_live
             |> element("a[phx-value-id=#{agency_model.id}]", "Delete")
             |> render_click()

      refute has_element?(index_live, "a[phx-value-id=#{agency_model.id}]")
    end
  end

  describe "Show" do
    setup [:create_agency_model]

    test "displays agency_model", %{conn: conn, agency_model: agency_model} do
      {:ok, _show_live, html} = live(conn, ~p"/catalogs/agency_models/#{agency_model}")

      assert html =~ "Show Agency model"
      assert html =~ agency_model.name
    end

    test "updates agency_model within modal", %{conn: conn, agency_model: agency_model} do
      {:ok, show_live, _html} = live(conn, ~p"/catalogs/agency_models/#{agency_model}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Agency model"

      assert_patch(show_live, ~p"/catalogs/agency_models/#{agency_model}/show/edit")

      assert show_live
             |> form("#agency_model-form", agency_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#agency_model-form", agency_model: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/catalogs/agency_models/#{agency_model}")

      assert html =~ "Agency model updated successfully"
      assert html =~ "some updated name"
    end
  end
end
