defmodule SurveyEngineWeb.SurveyMapperLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.SurveyMappersFixtures

  @create_attrs %{type: "some type", field: "some field", question_id: "some question_id"}
  @update_attrs %{type: "some updated type", field: "some updated field", question_id: "some updated question_id"}
  @invalid_attrs %{type: nil, field: nil, question_id: nil}

  defp create_survey_mapper(_) do
    survey_mapper = survey_mapper_fixture()
    %{survey_mapper: survey_mapper}
  end

  describe "Index" do
    setup [:create_survey_mapper]

    test "lists all survey_mapper", %{conn: conn, survey_mapper: survey_mapper} do
      {:ok, _index_live, html} = live(conn, ~p"/survey_mapper")

      assert html =~ "Listing Survey mapper"
      assert html =~ survey_mapper.type
    end

    test "saves new survey_mapper", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_mapper")

      assert index_live |> element("a", "New Survey mapper") |> render_click() =~
               "New Survey mapper"

      assert_patch(index_live, ~p"/survey_mapper/new")

      assert index_live
             |> form("#survey_mapper-form", survey_mapper: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#survey_mapper-form", survey_mapper: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_mapper")

      assert html =~ "Survey mapper created successfully"
      assert html =~ "some type"
    end

    test "updates survey_mapper in listing", %{conn: conn, survey_mapper: survey_mapper} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_mapper")

      assert index_live |> element("a[href='/survey_mapper/#{survey_mapper.id}/edit']", "Edit") |> render_click() =~
               "Edit Survey mapper"

      assert_patch(index_live, ~p"/survey_mapper/#{survey_mapper}/edit")

      assert index_live
             |> form("#survey_mapper-form", survey_mapper: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#survey_mapper-form", survey_mapper: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_mapper")

      assert html =~ "Survey mapper updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes survey_mapper in listing", %{conn: conn, survey_mapper: survey_mapper} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_mapper")

      assert index_live |> element("a[phx-value-id=#{survey_mapper.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{survey_mapper.id}]")
    end
  end

  describe "Show" do
    setup [:create_survey_mapper]

    test "displays survey_mapper", %{conn: conn, survey_mapper: survey_mapper} do
      {:ok, _show_live, html} = live(conn, ~p"/survey_mapper/#{survey_mapper}")

      assert html =~ "Show Survey mapper"
      assert html =~ survey_mapper.type
    end

    test "updates survey_mapper within modal", %{conn: conn, survey_mapper: survey_mapper} do
      {:ok, show_live, _html} = live(conn, ~p"/survey_mapper/#{survey_mapper}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Survey mapper"

      assert_patch(show_live, ~p"/survey_mapper/#{survey_mapper}/show/edit")

      assert show_live
             |> form("#survey_mapper-form", survey_mapper: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#survey_mapper-form", survey_mapper: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_mapper/#{survey_mapper}")

      assert html =~ "Survey mapper updated successfully"
      assert html =~ "some updated type"
    end
  end
end
