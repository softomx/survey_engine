defmodule SurveyEngine.CatalogsTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.Catalogs

  describe "currencies" do
    alias SurveyEngine.Catalogs.Currency

    import SurveyEngine.CatalogsFixtures

    @invalid_attrs %{active: nil, name: nil, slug: nil}

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Catalogs.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Catalogs.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      valid_attrs = %{active: true, name: "some name", slug: "some slug"}

      assert {:ok, %Currency{} = currency} = Catalogs.create_currency(valid_attrs)
      assert currency.active == true
      assert currency.name == "some name"
      assert currency.slug == "some slug"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogs.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      update_attrs = %{active: false, name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Currency{} = currency} = Catalogs.update_currency(currency, update_attrs)
      assert currency.active == false
      assert currency.name == "some updated name"
      assert currency.slug == "some updated slug"
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogs.update_currency(currency, @invalid_attrs)
      assert currency == Catalogs.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Catalogs.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Catalogs.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Catalogs.change_currency(currency)
    end
  end

  describe "agency_types" do
    alias SurveyEngine.Catalogs.AgencyType

    import SurveyEngine.CatalogsFixtures

    @invalid_attrs %{active: nil, name: nil}

    test "list_agency_types/0 returns all agency_types" do
      agency_type = agency_type_fixture()
      assert Catalogs.list_agency_types() == [agency_type]
    end

    test "get_agency_type!/1 returns the agency_type with given id" do
      agency_type = agency_type_fixture()
      assert Catalogs.get_agency_type!(agency_type.id) == agency_type
    end

    test "create_agency_type/1 with valid data creates a agency_type" do
      valid_attrs = %{active: true, name: "some name"}

      assert {:ok, %AgencyType{} = agency_type} = Catalogs.create_agency_type(valid_attrs)
      assert agency_type.active == true
      assert agency_type.name == "some name"
    end

    test "create_agency_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogs.create_agency_type(@invalid_attrs)
    end

    test "update_agency_type/2 with valid data updates the agency_type" do
      agency_type = agency_type_fixture()
      update_attrs = %{active: false, name: "some updated name"}

      assert {:ok, %AgencyType{} = agency_type} = Catalogs.update_agency_type(agency_type, update_attrs)
      assert agency_type.active == false
      assert agency_type.name == "some updated name"
    end

    test "update_agency_type/2 with invalid data returns error changeset" do
      agency_type = agency_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogs.update_agency_type(agency_type, @invalid_attrs)
      assert agency_type == Catalogs.get_agency_type!(agency_type.id)
    end

    test "delete_agency_type/1 deletes the agency_type" do
      agency_type = agency_type_fixture()
      assert {:ok, %AgencyType{}} = Catalogs.delete_agency_type(agency_type)
      assert_raise Ecto.NoResultsError, fn -> Catalogs.get_agency_type!(agency_type.id) end
    end

    test "change_agency_type/1 returns a agency_type changeset" do
      agency_type = agency_type_fixture()
      assert %Ecto.Changeset{} = Catalogs.change_agency_type(agency_type)
    end
  end

  describe "personal_titles" do
    alias SurveyEngine.Catalogs.PersonalTitle

    import SurveyEngine.CatalogsFixtures

    @invalid_attrs %{name: nil}

    test "list_personal_titles/0 returns all personal_titles" do
      personal_title = personal_title_fixture()
      assert Catalogs.list_personal_titles() == [personal_title]
    end

    test "get_personal_title!/1 returns the personal_title with given id" do
      personal_title = personal_title_fixture()
      assert Catalogs.get_personal_title!(personal_title.id) == personal_title
    end

    test "create_personal_title/1 with valid data creates a personal_title" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %PersonalTitle{} = personal_title} = Catalogs.create_personal_title(valid_attrs)
      assert personal_title.name == "some name"
    end

    test "create_personal_title/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogs.create_personal_title(@invalid_attrs)
    end

    test "update_personal_title/2 with valid data updates the personal_title" do
      personal_title = personal_title_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %PersonalTitle{} = personal_title} = Catalogs.update_personal_title(personal_title, update_attrs)
      assert personal_title.name == "some updated name"
    end

    test "update_personal_title/2 with invalid data returns error changeset" do
      personal_title = personal_title_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogs.update_personal_title(personal_title, @invalid_attrs)
      assert personal_title == Catalogs.get_personal_title!(personal_title.id)
    end

    test "delete_personal_title/1 deletes the personal_title" do
      personal_title = personal_title_fixture()
      assert {:ok, %PersonalTitle{}} = Catalogs.delete_personal_title(personal_title)
      assert_raise Ecto.NoResultsError, fn -> Catalogs.get_personal_title!(personal_title.id) end
    end

    test "change_personal_title/1 returns a personal_title changeset" do
      personal_title = personal_title_fixture()
      assert %Ecto.Changeset{} = Catalogs.change_personal_title(personal_title)
    end
  end

  describe "agency_models" do
    alias SurveyEngine.Catalogs.AgencyModel

    import SurveyEngine.CatalogsFixtures

    @invalid_attrs %{name: nil}

    test "list_agency_models/0 returns all agency_models" do
      agency_model = agency_model_fixture()
      assert Catalogs.list_agency_models() == [agency_model]
    end

    test "get_agency_model!/1 returns the agency_model with given id" do
      agency_model = agency_model_fixture()
      assert Catalogs.get_agency_model!(agency_model.id) == agency_model
    end

    test "create_agency_model/1 with valid data creates a agency_model" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %AgencyModel{} = agency_model} = Catalogs.create_agency_model(valid_attrs)
      assert agency_model.name == "some name"
    end

    test "create_agency_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogs.create_agency_model(@invalid_attrs)
    end

    test "update_agency_model/2 with valid data updates the agency_model" do
      agency_model = agency_model_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %AgencyModel{} = agency_model} = Catalogs.update_agency_model(agency_model, update_attrs)
      assert agency_model.name == "some updated name"
    end

    test "update_agency_model/2 with invalid data returns error changeset" do
      agency_model = agency_model_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogs.update_agency_model(agency_model, @invalid_attrs)
      assert agency_model == Catalogs.get_agency_model!(agency_model.id)
    end

    test "delete_agency_model/1 deletes the agency_model" do
      agency_model = agency_model_fixture()
      assert {:ok, %AgencyModel{}} = Catalogs.delete_agency_model(agency_model)
      assert_raise Ecto.NoResultsError, fn -> Catalogs.get_agency_model!(agency_model.id) end
    end

    test "change_agency_model/1 returns a agency_model changeset" do
      agency_model = agency_model_fixture()
      assert %Ecto.Changeset{} = Catalogs.change_agency_model(agency_model)
    end
  end
end
