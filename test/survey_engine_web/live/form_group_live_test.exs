defmodule SurveyEngineWeb.FormGroupLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.LeadsFormsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_form_group(_) do
    form_group = form_group_fixture()
    %{form_group: form_group}
  end

  describe "Index" do
    setup [:create_form_group]

    test "lists all form_groups", %{conn: conn, form_group: form_group} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/form_groups")

      assert html =~ "Listing Form groups"
      assert html =~ form_group.name
    end

    test "saves new form_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/form_groups")

      assert index_live |> element("a", "New Form group") |> render_click() =~
               "New Form group"

      assert_patch(index_live, ~p"/admin/form_groups/new")

      assert index_live
             |> form("#form_group-form", form_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#form_group-form", form_group: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/form_groups")

      assert html =~ "Form group created successfully"
      assert html =~ "some name"
    end

    test "updates form_group in listing", %{conn: conn, form_group: form_group} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/form_groups")

      assert index_live
             |> element("a[href='/form_groups/#{form_group.id}/edit']", "Edit")
             |> render_click() =~
               "Edit Form group"

      assert_patch(index_live, ~p"/admin/form_groups/#{form_group}/edit")

      assert index_live
             |> form("#form_group-form", form_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#form_group-form", form_group: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/form_groups")

      assert html =~ "Form group updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes form_group in listing", %{conn: conn, form_group: form_group} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/form_groups")

      assert index_live |> element("a[phx-value-id=#{form_group.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{form_group.id}]")
    end
  end

  describe "Show" do
    setup [:create_form_group]

    test "displays form_group", %{conn: conn, form_group: form_group} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/form_groups/#{form_group}")

      assert html =~ "Show Form group"
      assert html =~ form_group.name
    end

    test "updates form_group within modal", %{conn: conn, form_group: form_group} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/form_groups/#{form_group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Form group"

      assert_patch(show_live, ~p"/admin/form_groups/#{form_group}/show/edit")

      assert show_live
             |> form("#form_group-form", form_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#form_group-form", form_group: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/form_groups/#{form_group}")

      assert html =~ "Form group updated successfully"
      assert html =~ "some updated name"
    end
  end
end
