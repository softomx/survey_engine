defmodule SurveyEngine.BusinessModelsTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.BusinessModels

  describe "business_models" do
    alias SurveyEngine.BusinessModels.BusinessModel

    import SurveyEngine.BusinessModelsFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_business_models/0 returns all business_models" do
      business_model = business_model_fixture()
      assert BusinessModels.list_business_models() == [business_model]
    end

    test "get_business_model!/1 returns the business_model with given id" do
      business_model = business_model_fixture()
      assert BusinessModels.get_business_model!(business_model.id) == business_model
    end

    test "create_business_model/1 with valid data creates a business_model" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %BusinessModel{} = business_model} = BusinessModels.create_business_model(valid_attrs)
      assert business_model.name == "some name"
      assert business_model.slug == "some slug"
    end

    test "create_business_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BusinessModels.create_business_model(@invalid_attrs)
    end

    test "update_business_model/2 with valid data updates the business_model" do
      business_model = business_model_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %BusinessModel{} = business_model} = BusinessModels.update_business_model(business_model, update_attrs)
      assert business_model.name == "some updated name"
      assert business_model.slug == "some updated slug"
    end

    test "update_business_model/2 with invalid data returns error changeset" do
      business_model = business_model_fixture()
      assert {:error, %Ecto.Changeset{}} = BusinessModels.update_business_model(business_model, @invalid_attrs)
      assert business_model == BusinessModels.get_business_model!(business_model.id)
    end

    test "delete_business_model/1 deletes the business_model" do
      business_model = business_model_fixture()
      assert {:ok, %BusinessModel{}} = BusinessModels.delete_business_model(business_model)
      assert_raise Ecto.NoResultsError, fn -> BusinessModels.get_business_model!(business_model.id) end
    end

    test "change_business_model/1 returns a business_model changeset" do
      business_model = business_model_fixture()
      assert %Ecto.Changeset{} = BusinessModels.change_business_model(business_model)
    end
  end

  describe "business_configs" do
    alias SurveyEngine.BusinessModels.BusinessConfig

    import SurveyEngine.BusinessModelsFixtures

    @invalid_attrs %{required: nil, order: nil, previous_lead_form_finished: nil}

    test "list_business_configs/0 returns all business_configs" do
      business_config = business_config_fixture()
      assert BusinessModels.list_business_configs() == [business_config]
    end

    test "get_business_config!/1 returns the business_config with given id" do
      business_config = business_config_fixture()
      assert BusinessModels.get_business_config!(business_config.id) == business_config
    end

    test "create_business_config/1 with valid data creates a business_config" do
      valid_attrs = %{required: true, order: 42, previous_lead_form_finished: []}

      assert {:ok, %BusinessConfig{} = business_config} = BusinessModels.create_business_config(valid_attrs)
      assert business_config.required == true
      assert business_config.order == 42
      assert business_config.previous_lead_form_finished == []
    end

    test "create_business_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BusinessModels.create_business_config(@invalid_attrs)
    end

    test "update_business_config/2 with valid data updates the business_config" do
      business_config = business_config_fixture()
      update_attrs = %{required: false, order: 43, previous_lead_form_finished: []}

      assert {:ok, %BusinessConfig{} = business_config} = BusinessModels.update_business_config(business_config, update_attrs)
      assert business_config.required == false
      assert business_config.order == 43
      assert business_config.previous_lead_form_finished == []
    end

    test "update_business_config/2 with invalid data returns error changeset" do
      business_config = business_config_fixture()
      assert {:error, %Ecto.Changeset{}} = BusinessModels.update_business_config(business_config, @invalid_attrs)
      assert business_config == BusinessModels.get_business_config!(business_config.id)
    end

    test "delete_business_config/1 deletes the business_config" do
      business_config = business_config_fixture()
      assert {:ok, %BusinessConfig{}} = BusinessModels.delete_business_config(business_config)
      assert_raise Ecto.NoResultsError, fn -> BusinessModels.get_business_config!(business_config.id) end
    end

    test "change_business_config/1 returns a business_config changeset" do
      business_config = business_config_fixture()
      assert %Ecto.Changeset{} = BusinessModels.change_business_config(business_config)
    end
  end
end
