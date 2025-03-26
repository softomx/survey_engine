defmodule SurveyEngineWeb.TranslationLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.TranslationsFixtures

  @create_attrs %{type: "some type", description: "some description"}
  @update_attrs %{type: "some updated type", description: "some updated description"}
  @invalid_attrs %{type: nil, description: nil}

  defp create_translation(_) do
    translation = translation_fixture()
    %{translation: translation}
  end

  describe "Index" do
    setup [:create_translation]

    test "lists all translations", %{conn: conn, translation: translation} do
      {:ok, _index_live, html} = live(conn, ~p"/translations")

      assert html =~ "Listing Translations"
      assert html =~ translation.type
    end

    test "saves new translation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/translations")

      assert index_live |> element("a", "New Translation") |> render_click() =~
               "New Translation"

      assert_patch(index_live, ~p"/translations/new")

      assert index_live
             |> form("#translation-form", translation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#translation-form", translation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/translations")

      html = render(index_live)
      assert html =~ "Translation created successfully"
      assert html =~ "some type"
    end

    test "updates translation in listing", %{conn: conn, translation: translation} do
      {:ok, index_live, _html} = live(conn, ~p"/translations")

      assert index_live |> element("#translations-#{translation.id} a", "Edit") |> render_click() =~
               "Edit Translation"

      assert_patch(index_live, ~p"/translations/#{translation}/edit")

      assert index_live
             |> form("#translation-form", translation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#translation-form", translation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/translations")

      html = render(index_live)
      assert html =~ "Translation updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes translation in listing", %{conn: conn, translation: translation} do
      {:ok, index_live, _html} = live(conn, ~p"/translations")

      assert index_live |> element("#translations-#{translation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#translations-#{translation.id}")
    end
  end

  describe "Show" do
    setup [:create_translation]

    test "displays translation", %{conn: conn, translation: translation} do
      {:ok, _show_live, html} = live(conn, ~p"/translations/#{translation}")

      assert html =~ "Show Translation"
      assert html =~ translation.type
    end

    test "updates translation within modal", %{conn: conn, translation: translation} do
      {:ok, show_live, _html} = live(conn, ~p"/translations/#{translation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Translation"

      assert_patch(show_live, ~p"/translations/#{translation}/show/edit")

      assert show_live
             |> form("#translation-form", translation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#translation-form", translation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/translations/#{translation}")

      html = render(show_live)
      assert html =~ "Translation updated successfully"
      assert html =~ "some updated type"
    end
  end
end
