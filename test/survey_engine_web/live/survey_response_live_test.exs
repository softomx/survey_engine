defmodule SurveyEngineWeb.SurveyResponseLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.ResponsesFixtures

  @create_attrs %{data: %{}, date: "2025-03-04", state: "some state"}
  @update_attrs %{data: %{}, date: "2025-03-05", state: "some updated state"}
  @invalid_attrs %{data: nil, date: nil, state: nil}

  defp create_survey_response(_) do
    survey_response = survey_response_fixture()
    %{survey_response: survey_response}
  end

  describe "Index" do
    setup [:create_survey_response]

    test "lists all survey_responses", %{conn: conn, survey_response: survey_response} do
      {:ok, _index_live, html} = live(conn, ~p"/survey_responses")

      assert html =~ "Listing Survey responses"
      assert html =~ survey_response.state
    end

    test "saves new survey_response", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_responses")

      assert index_live |> element("a", "New Survey response") |> render_click() =~
               "New Survey response"

      assert_patch(index_live, ~p"/survey_responses/new")

      assert index_live
             |> form("#survey_response-form", survey_response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#survey_response-form", survey_response: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_responses")

      assert html =~ "Survey response created successfully"
      assert html =~ "some state"
    end

    test "updates survey_response in listing", %{conn: conn, survey_response: survey_response} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_responses")

      assert index_live |> element("a[href='/survey_responses/#{survey_response.id}/edit']", "Edit") |> render_click() =~
               "Edit Survey response"

      assert_patch(index_live, ~p"/survey_responses/#{survey_response}/edit")

      assert index_live
             |> form("#survey_response-form", survey_response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#survey_response-form", survey_response: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_responses")

      assert html =~ "Survey response updated successfully"
      assert html =~ "some updated state"
    end

    test "deletes survey_response in listing", %{conn: conn, survey_response: survey_response} do
      {:ok, index_live, _html} = live(conn, ~p"/survey_responses")

      assert index_live |> element("a[phx-value-id=#{survey_response.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{survey_response.id}]")
    end
  end

  describe "Show" do
    setup [:create_survey_response]

    test "displays survey_response", %{conn: conn, survey_response: survey_response} do
      {:ok, _show_live, html} = live(conn, ~p"/survey_responses/#{survey_response}")

      assert html =~ "Show Survey response"
      assert html =~ survey_response.state
    end

    test "updates survey_response within modal", %{conn: conn, survey_response: survey_response} do
      {:ok, show_live, _html} = live(conn, ~p"/survey_responses/#{survey_response}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Survey response"

      assert_patch(show_live, ~p"/survey_responses/#{survey_response}/show/edit")

      assert show_live
             |> form("#survey_response-form", survey_response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#survey_response-form", survey_response: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/survey_responses/#{survey_response}")

      assert html =~ "Survey response updated successfully"
      assert html =~ "some updated state"
    end
  end
end
