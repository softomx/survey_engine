defmodule SurveyEngineWeb.BusinessConfigLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.BusinessModelsFixtures

  @create_attrs %{required: true, order: 42, previous_lead_form_finished: []}
  @update_attrs %{required: false, order: 43, previous_lead_form_finished: []}
  @invalid_attrs %{required: false, order: nil, previous_lead_form_finished: []}

  defp create_business_config(_) do
    business_config = business_config_fixture()
    %{business_config: business_config}
  end

  describe "Index" do
    setup [:create_business_config]

    test "lists all business_configs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/business_configs")

      assert html =~ "Listing Business configs"
    end

    test "saves new business_config", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/business_configs")

      assert index_live |> element("a", "New Business config") |> render_click() =~
               "New Business config"

      assert_patch(index_live, ~p"/business_configs/new")

      assert index_live
             |> form("#business_config-form", business_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business_config-form", business_config: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_configs")

      assert html =~ "Business config created successfully"
    end

    test "updates business_config in listing", %{conn: conn, business_config: business_config} do
      {:ok, index_live, _html} = live(conn, ~p"/business_configs")

      assert index_live |> element("a[href='/business_configs/#{business_config.id}/edit']", "Edit") |> render_click() =~
               "Edit Business config"

      assert_patch(index_live, ~p"/business_configs/#{business_config}/edit")

      assert index_live
             |> form("#business_config-form", business_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business_config-form", business_config: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_configs")

      assert html =~ "Business config updated successfully"
    end

    test "deletes business_config in listing", %{conn: conn, business_config: business_config} do
      {:ok, index_live, _html} = live(conn, ~p"/business_configs")

      assert index_live |> element("a[phx-value-id=#{business_config.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{business_config.id}]")
    end
  end

  describe "Show" do
    setup [:create_business_config]

    test "displays business_config", %{conn: conn, business_config: business_config} do
      {:ok, _show_live, html} = live(conn, ~p"/business_configs/#{business_config}")

      assert html =~ "Show Business config"
    end

    test "updates business_config within modal", %{conn: conn, business_config: business_config} do
      {:ok, show_live, _html} = live(conn, ~p"/business_configs/#{business_config}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Business config"

      assert_patch(show_live, ~p"/business_configs/#{business_config}/show/edit")

      assert show_live
             |> form("#business_config-form", business_config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#business_config-form", business_config: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/business_configs/#{business_config}")

      assert html =~ "Business config updated successfully"
    end
  end
end
