defmodule SurveyEngineWeb.LeadsFormLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.LeadsFormsFixtures

  @create_attrs %{active: true, name: "some name", language: "some language", external_id: "some external_id"}
  @update_attrs %{active: false, name: "some updated name", language: "some updated language", external_id: "some updated external_id"}
  @invalid_attrs %{active: false, name: nil, language: nil, external_id: nil}

  defp create_leads_form(_) do
    leads_form = leads_form_fixture()
    %{leads_form: leads_form}
  end

  describe "Index" do
    setup [:create_leads_form]

    test "lists all leads_forms", %{conn: conn, leads_form: leads_form} do
      {:ok, _index_live, html} = live(conn, ~p"/leads_forms")

      assert html =~ "Listing Leads forms"
      assert html =~ leads_form.name
    end

    test "saves new leads_form", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/leads_forms")

      assert index_live |> element("a", "New Leads form") |> render_click() =~
               "New Leads form"

      assert_patch(index_live, ~p"/leads_forms/new")

      assert index_live
             |> form("#leads_form-form", leads_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leads_form-form", leads_form: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leads_forms")

      html = render(index_live)
      assert html =~ "Leads form created successfully"
      assert html =~ "some name"
    end

    test "updates leads_form in listing", %{conn: conn, leads_form: leads_form} do
      {:ok, index_live, _html} = live(conn, ~p"/leads_forms")

      assert index_live |> element("#leads_forms-#{leads_form.id} a", "Edit") |> render_click() =~
               "Edit Leads form"

      assert_patch(index_live, ~p"/leads_forms/#{leads_form}/edit")

      assert index_live
             |> form("#leads_form-form", leads_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leads_form-form", leads_form: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leads_forms")

      html = render(index_live)
      assert html =~ "Leads form updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes leads_form in listing", %{conn: conn, leads_form: leads_form} do
      {:ok, index_live, _html} = live(conn, ~p"/leads_forms")

      assert index_live |> element("#leads_forms-#{leads_form.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leads_forms-#{leads_form.id}")
    end
  end

  describe "Show" do
    setup [:create_leads_form]

    test "displays leads_form", %{conn: conn, leads_form: leads_form} do
      {:ok, _show_live, html} = live(conn, ~p"/leads_forms/#{leads_form}")

      assert html =~ "Show Leads form"
      assert html =~ leads_form.name
    end

    test "updates leads_form within modal", %{conn: conn, leads_form: leads_form} do
      {:ok, show_live, _html} = live(conn, ~p"/leads_forms/#{leads_form}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Leads form"

      assert_patch(show_live, ~p"/leads_forms/#{leads_form}/show/edit")

      assert show_live
             |> form("#leads_form-form", leads_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#leads_form-form", leads_form: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/leads_forms/#{leads_form}")

      html = render(show_live)
      assert html =~ "Leads form updated successfully"
      assert html =~ "some updated name"
    end
  end
end
