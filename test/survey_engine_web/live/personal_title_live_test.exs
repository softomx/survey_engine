defmodule SurveyEngineWeb.PersonalTitleLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.CatalogsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_personal_title(_) do
    personal_title = personal_title_fixture()
    %{personal_title: personal_title}
  end

  describe "Index" do
    setup [:create_personal_title]

    test "lists all personal_titles", %{conn: conn, personal_title: personal_title} do
      {:ok, _index_live, html} = live(conn, ~p"/personal_titles")

      assert html =~ "Listing Personal titles"
      assert html =~ personal_title.name
    end

    test "saves new personal_title", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/personal_titles")

      assert index_live |> element("a", "New Personal title") |> render_click() =~
               "New Personal title"

      assert_patch(index_live, ~p"/personal_titles/new")

      assert index_live
             |> form("#personal_title-form", personal_title: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#personal_title-form", personal_title: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/personal_titles")

      assert html =~ "Personal title created successfully"
      assert html =~ "some name"
    end

    test "updates personal_title in listing", %{conn: conn, personal_title: personal_title} do
      {:ok, index_live, _html} = live(conn, ~p"/personal_titles")

      assert index_live |> element("a[href='/personal_titles/#{personal_title.id}/edit']", "Edit") |> render_click() =~
               "Edit Personal title"

      assert_patch(index_live, ~p"/personal_titles/#{personal_title}/edit")

      assert index_live
             |> form("#personal_title-form", personal_title: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#personal_title-form", personal_title: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/personal_titles")

      assert html =~ "Personal title updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes personal_title in listing", %{conn: conn, personal_title: personal_title} do
      {:ok, index_live, _html} = live(conn, ~p"/personal_titles")

      assert index_live |> element("a[phx-value-id=#{personal_title.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{personal_title.id}]")
    end
  end

  describe "Show" do
    setup [:create_personal_title]

    test "displays personal_title", %{conn: conn, personal_title: personal_title} do
      {:ok, _show_live, html} = live(conn, ~p"/personal_titles/#{personal_title}")

      assert html =~ "Show Personal title"
      assert html =~ personal_title.name
    end

    test "updates personal_title within modal", %{conn: conn, personal_title: personal_title} do
      {:ok, show_live, _html} = live(conn, ~p"/personal_titles/#{personal_title}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Personal title"

      assert_patch(show_live, ~p"/personal_titles/#{personal_title}/show/edit")

      assert show_live
             |> form("#personal_title-form", personal_title: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#personal_title-form", personal_title: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/personal_titles/#{personal_title}")

      assert html =~ "Personal title updated successfully"
      assert html =~ "some updated name"
    end
  end
end
