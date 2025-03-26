defmodule SurveyEngineWeb.BusinessModelLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.BusinessModelsFixtures

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  defp create_business_model(_) do
    business_model = business_model_fixture()
    %{business_model: business_model}
  end

  describe "Index" do
    setup [:create_business_model]

    test "lists all business_models", %{conn: conn, business_model: business_model} do
      {:ok, _index_live, html} = live(conn, ~p"/business_models")

      assert html =~ "Listing Business models"
      assert html =~ business_model.name
    end

    test "saves new business_model", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/business_models")

      assert index_live |> element("a", "New Business model") |> render_click() =~
               "New Business model"

      assert_patch(index_live, ~p"/business_models/new")

      assert index_live
             |> form("#business_model-form", business_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business_model-form", business_model: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_models")

      assert html =~ "Business model created successfully"
      assert html =~ "some name"
    end

    test "updates business_model in listing", %{conn: conn, business_model: business_model} do
      {:ok, index_live, _html} = live(conn, ~p"/business_models")

      assert index_live |> element("a[href='/business_models/#{business_model.id}/edit']", "Edit") |> render_click() =~
               "Edit Business model"

      assert_patch(index_live, ~p"/business_models/#{business_model}/edit")

      assert index_live
             |> form("#business_model-form", business_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business_model-form", business_model: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_models")

      assert html =~ "Business model updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes business_model in listing", %{conn: conn, business_model: business_model} do
      {:ok, index_live, _html} = live(conn, ~p"/business_models")

      assert index_live |> element("a[phx-value-id=#{business_model.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{business_model.id}]")
    end
  end

  describe "Show" do
    setup [:create_business_model]

    test "displays business_model", %{conn: conn, business_model: business_model} do
      {:ok, _show_live, html} = live(conn, ~p"/business_models/#{business_model}")

      assert html =~ "Show Business model"
      assert html =~ business_model.name
    end

    test "updates business_model within modal", %{conn: conn, business_model: business_model} do
      {:ok, show_live, _html} = live(conn, ~p"/business_models/#{business_model}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Business model"

      assert_patch(show_live, ~p"/business_models/#{business_model}/show/edit")

      assert show_live
             |> form("#business_model-form", business_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#business_model-form", business_model: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_models/#{business_model}")

      assert html =~ "Business model updated successfully"
      assert html =~ "some updated name"
    end
  end
end
