defmodule SurveyEngine.CompaniesTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.Companies

  describe "companies" do
    alias SurveyEngine.Companies.Company

    import SurveyEngine.CompaniesFixtures

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

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{
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

      assert {:ok, %Company{} = company} =
               Companies.create_company(valid_attrs)

      assert company.date == "some date"
      assert company.language == "some language"
      assert company.agency_name == "some agency_name"
      assert company.rfc == "some rfc"
      assert company.legal_name == "some legal_name"
      assert company.country == "some country"
      assert company.town == "some town"
      assert company.city == "some city"
      assert company.agency_type == "some agency_type"
      assert company.billing_currency == "some billing_currency"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()

      update_attrs = %{
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

      assert {:ok, %Company{} = company} =
               Companies.update_company(company, update_attrs)

      assert company.date == "some updated date"
      assert company.language == "some updated language"
      assert company.agency_name == "some updated agency_name"
      assert company.rfc == "some updated rfc"
      assert company.legal_name == "some updated legal_name"
      assert company.country == "some updated country"
      assert company.town == "some updated town"
      assert company.city == "some updated city"
      assert company.agency_type == "some updated agency_type"
      assert company.billing_currency == "some updated billing_currency"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_company(company, @invalid_attrs)

      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)

      assert_raise Ecto.NoResultsError, fn ->
        Companies.get_company!(company.id)
      end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
