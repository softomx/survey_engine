defmodule SurveyEngineWeb.AffiliateLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.AffiliateEngineFixtures

  @create_attrs %{name: "some name", affiliate_slug: "some affiliate_slug", trading_name: "some trading_name", business_name: "some business_name", rfc: "some rfc", company_type: "some company_type"}
  @update_attrs %{name: "some updated name", affiliate_slug: "some updated affiliate_slug", trading_name: "some updated trading_name", business_name: "some updated business_name", rfc: "some updated rfc", company_type: "some updated company_type"}
  @invalid_attrs %{name: nil, affiliate_slug: nil, trading_name: nil, business_name: nil, rfc: nil, company_type: nil}

  defp create_affiliate(_) do
    affiliate = affiliate_fixture()
    %{affiliate: affiliate}
  end

  describe "Index" do
    setup [:create_affiliate]

    test "lists all affiliates", %{conn: conn, affiliate: affiliate} do
      {:ok, _index_live, html} = live(conn, ~p"/affiliates")

      assert html =~ "Listing Affiliates"
      assert html =~ affiliate.name
    end

    test "saves new affiliate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/affiliates")

      assert index_live |> element("a", "New Affiliate") |> render_click() =~
               "New Affiliate"

      assert_patch(index_live, ~p"/affiliates/new")

      assert index_live
             |> form("#affiliate-form", affiliate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#affiliate-form", affiliate: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/affiliates")

      assert html =~ "Affiliate created successfully"
      assert html =~ "some name"
    end

    test "updates affiliate in listing", %{conn: conn, affiliate: affiliate} do
      {:ok, index_live, _html} = live(conn, ~p"/affiliates")

      assert index_live |> element("a[href='/affiliates/#{affiliate.id}/edit']", "Edit") |> render_click() =~
               "Edit Affiliate"

      assert_patch(index_live, ~p"/affiliates/#{affiliate}/edit")

      assert index_live
             |> form("#affiliate-form", affiliate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#affiliate-form", affiliate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/affiliates")

      assert html =~ "Affiliate updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes affiliate in listing", %{conn: conn, affiliate: affiliate} do
      {:ok, index_live, _html} = live(conn, ~p"/affiliates")

      assert index_live |> element("a[phx-value-id=#{affiliate.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{affiliate.id}]")
    end
  end

  describe "Show" do
    setup [:create_affiliate]

    test "displays affiliate", %{conn: conn, affiliate: affiliate} do
      {:ok, _show_live, html} = live(conn, ~p"/affiliates/#{affiliate}")

      assert html =~ "Show Affiliate"
      assert html =~ affiliate.name
    end

    test "updates affiliate within modal", %{conn: conn, affiliate: affiliate} do
      {:ok, show_live, _html} = live(conn, ~p"/affiliates/#{affiliate}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Affiliate"

      assert_patch(show_live, ~p"/affiliates/#{affiliate}/show/edit")

      assert show_live
             |> form("#affiliate-form", affiliate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#affiliate-form", affiliate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/affiliates/#{affiliate}")

      assert html =~ "Affiliate updated successfully"
      assert html =~ "some updated name"
    end
  end
end
