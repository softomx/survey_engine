defmodule SurveyEngine.SurveyMappersTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.SurveyMappers

  describe "survey_mapper" do
    alias SurveyEngine.SurveyMappers.SurveyMapper

    import SurveyEngine.SurveyMappersFixtures

    @invalid_attrs %{type: nil, field: nil, question_id: nil}

    test "list_survey_mapper/0 returns all survey_mapper" do
      survey_mapper = survey_mapper_fixture()
      assert SurveyMappers.list_survey_mapper() == [survey_mapper]
    end

    test "get_survey_mapper!/1 returns the survey_mapper with given id" do
      survey_mapper = survey_mapper_fixture()
      assert SurveyMappers.get_survey_mapper!(survey_mapper.id) == survey_mapper
    end

    test "create_survey_mapper/1 with valid data creates a survey_mapper" do
      valid_attrs = %{type: "some type", field: "some field", question_id: "some question_id"}

      assert {:ok, %SurveyMapper{} = survey_mapper} = SurveyMappers.create_survey_mapper(valid_attrs)
      assert survey_mapper.type == "some type"
      assert survey_mapper.field == "some field"
      assert survey_mapper.question_id == "some question_id"
    end

    test "create_survey_mapper/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SurveyMappers.create_survey_mapper(@invalid_attrs)
    end

    test "update_survey_mapper/2 with valid data updates the survey_mapper" do
      survey_mapper = survey_mapper_fixture()
      update_attrs = %{type: "some updated type", field: "some updated field", question_id: "some updated question_id"}

      assert {:ok, %SurveyMapper{} = survey_mapper} = SurveyMappers.update_survey_mapper(survey_mapper, update_attrs)
      assert survey_mapper.type == "some updated type"
      assert survey_mapper.field == "some updated field"
      assert survey_mapper.question_id == "some updated question_id"
    end

    test "update_survey_mapper/2 with invalid data returns error changeset" do
      survey_mapper = survey_mapper_fixture()
      assert {:error, %Ecto.Changeset{}} = SurveyMappers.update_survey_mapper(survey_mapper, @invalid_attrs)
      assert survey_mapper == SurveyMappers.get_survey_mapper!(survey_mapper.id)
    end

    test "delete_survey_mapper/1 deletes the survey_mapper" do
      survey_mapper = survey_mapper_fixture()
      assert {:ok, %SurveyMapper{}} = SurveyMappers.delete_survey_mapper(survey_mapper)
      assert_raise Ecto.NoResultsError, fn -> SurveyMappers.get_survey_mapper!(survey_mapper.id) end
    end

    test "change_survey_mapper/1 returns a survey_mapper changeset" do
      survey_mapper = survey_mapper_fixture()
      assert %Ecto.Changeset{} = SurveyMappers.change_survey_mapper(survey_mapper)
    end
  end
end
