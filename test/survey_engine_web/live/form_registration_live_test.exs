defmodule SurveyEngineWeb.CompanyLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.CompaniesFixtures

  @create_attrs %{
    date: "some date",
    language: "some language",
    agency_name: "some agency_name",
    rfc: "some rfc",
    legal_name: "some legal_name",
    country: "some country",
    town: "some town",
    city: "some city",
    agency_type: "some agency_type",
    billing_currency: "some billing_currency"
  }
  @update_attrs %{
    date: "some updated date",
    language: "some updated language",
    agency_name: "some updated agency_name",
    rfc: "some updated rfc",
    legal_name: "some updated legal_name",
    country: "some updated country",
    town: "some updated town",
    city: "some updated city",
    agency_type: "some updated agency_type",
    billing_currency: "some updated billing_currency"
  }
  @invalid_attrs %{
    date: nil,
    language: nil,
    agency_name: nil,
    rfc: nil,
    legal_name: nil,
    country: nil,
    town: nil,
    city: nil,
    agency_type: nil,
    billing_currency: nil
  }

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  describe "Index" do
    setup [:create_company]

    test "lists all companies", %{conn: conn, company: company} do
      {:ok, _index_live, html} = live(conn, ~p"/companies")

      assert html =~ "Listing Form registrations"
      assert html =~ company.date
    end

    test "saves new company", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live |> element("a", "New Form registration") |> render_click() =~
               "New Form registration"

      assert_patch(index_live, ~p"/companies/new")

      assert index_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#company-form", company: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/companies")

      html = render(index_live)
      assert html =~ "Form registration created successfully"
      assert html =~ "some date"
    end

    test "updates company in listing", %{
      conn: conn,
      company: company
    } do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live
             |> element("#companies-#{company.id} a", "Edit")
             |> render_click() =~
               "Edit Form registration"

      assert_patch(index_live, ~p"/companies/#{company}/edit")

      assert index_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#company-form", company: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/companies")

      html = render(index_live)
      assert html =~ "Form registration updated successfully"
      assert html =~ "some updated date"
    end

    test "deletes company in listing", %{
      conn: conn,
      company: company
    } do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live
             |> element("#companies-#{company.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#companies-#{company.id}")
    end
  end

  describe "Show" do
    setup [:create_company]

    test "displays company", %{conn: conn, company: company} do
      {:ok, _show_live, html} = live(conn, ~p"/companies/#{company}")

      assert html =~ "Show Form registration"
      assert html =~ company.date
    end

    test "updates company within modal", %{
      conn: conn,
      company: company
    } do
      {:ok, show_live, _html} = live(conn, ~p"/companies/#{company}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Form registration"

      assert_patch(show_live, ~p"/companies/#{company}/show/edit")

      assert show_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#company-form", company: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/companies/#{company}")

      html = render(show_live)
      assert html =~ "Form registration updated successfully"
      assert html =~ "some updated date"
    end
  end
end
