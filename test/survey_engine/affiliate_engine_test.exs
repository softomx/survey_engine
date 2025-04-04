defmodule SurveyEngine.AffiliateEngineTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.AffiliateEngine

  describe "affiliates" do
    alias SurveyEngine.AffiliateEngine.Affiliate

    import SurveyEngine.AffiliateEngineFixtures

    @invalid_attrs %{name: nil, affiliate_slug: nil, trading_name: nil, business_name: nil, rfc: nil, company_type: nil}

    test "list_affiliates/0 returns all affiliates" do
      affiliate = affiliate_fixture()
      assert AffiliateEngine.list_affiliates() == [affiliate]
    end

    test "get_affiliate!/1 returns the affiliate with given id" do
      affiliate = affiliate_fixture()
      assert AffiliateEngine.get_affiliate!(affiliate.id) == affiliate
    end

    test "create_affiliate/1 with valid data creates a affiliate" do
      valid_attrs = %{name: "some name", affiliate_slug: "some affiliate_slug", trading_name: "some trading_name", business_name: "some business_name", rfc: "some rfc", company_type: "some company_type"}

      assert {:ok, %Affiliate{} = affiliate} = AffiliateEngine.create_affiliate(valid_attrs)
      assert affiliate.name == "some name"
      assert affiliate.affiliate_slug == "some affiliate_slug"
      assert affiliate.trading_name == "some trading_name"
      assert affiliate.business_name == "some business_name"
      assert affiliate.rfc == "some rfc"
      assert affiliate.company_type == "some company_type"
    end

    test "create_affiliate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AffiliateEngine.create_affiliate(@invalid_attrs)
    end

    test "update_affiliate/2 with valid data updates the affiliate" do
      affiliate = affiliate_fixture()
      update_attrs = %{name: "some updated name", affiliate_slug: "some updated affiliate_slug", trading_name: "some updated trading_name", business_name: "some updated business_name", rfc: "some updated rfc", company_type: "some updated company_type"}

      assert {:ok, %Affiliate{} = affiliate} = AffiliateEngine.update_affiliate(affiliate, update_attrs)
      assert affiliate.name == "some updated name"
      assert affiliate.affiliate_slug == "some updated affiliate_slug"
      assert affiliate.trading_name == "some updated trading_name"
      assert affiliate.business_name == "some updated business_name"
      assert affiliate.rfc == "some updated rfc"
      assert affiliate.company_type == "some updated company_type"
    end

    test "update_affiliate/2 with invalid data returns error changeset" do
      affiliate = affiliate_fixture()
      assert {:error, %Ecto.Changeset{}} = AffiliateEngine.update_affiliate(affiliate, @invalid_attrs)
      assert affiliate == AffiliateEngine.get_affiliate!(affiliate.id)
    end

    test "delete_affiliate/1 deletes the affiliate" do
      affiliate = affiliate_fixture()
      assert {:ok, %Affiliate{}} = AffiliateEngine.delete_affiliate(affiliate)
      assert_raise Ecto.NoResultsError, fn -> AffiliateEngine.get_affiliate!(affiliate.id) end
    end

    test "change_affiliate/1 returns a affiliate changeset" do
      affiliate = affiliate_fixture()
      assert %Ecto.Changeset{} = AffiliateEngine.change_affiliate(affiliate)
    end
  end
end
