defmodule SurveyEngine.ResponsesTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.Responses

  describe "survey_responses" do
    alias SurveyEngine.Responses.SurveyResponse

    import SurveyEngine.ResponsesFixtures

    @invalid_attrs %{data: nil, date: nil, state: nil}

    test "list_survey_responses/0 returns all survey_responses" do
      survey_response = survey_response_fixture()
      assert Responses.list_survey_responses() == [survey_response]
    end

    test "get_survey_response!/1 returns the survey_response with given id" do
      survey_response = survey_response_fixture()
      assert Responses.get_survey_response!(survey_response.id) == survey_response
    end

    test "create_survey_response/1 with valid data creates a survey_response" do
      valid_attrs = %{data: %{}, date: ~D[2025-03-04], state: "some state"}

      assert {:ok, %SurveyResponse{} = survey_response} = Responses.create_survey_response(valid_attrs)
      assert survey_response.data == %{}
      assert survey_response.date == ~D[2025-03-04]
      assert survey_response.state == "some state"
    end

    test "create_survey_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Responses.create_survey_response(@invalid_attrs)
    end

    test "update_survey_response/2 with valid data updates the survey_response" do
      survey_response = survey_response_fixture()
      update_attrs = %{data: %{}, date: ~D[2025-03-05], state: "some updated state"}

      assert {:ok, %SurveyResponse{} = survey_response} = Responses.update_survey_response(survey_response, update_attrs)
      assert survey_response.data == %{}
      assert survey_response.date == ~D[2025-03-05]
      assert survey_response.state == "some updated state"
    end

    test "update_survey_response/2 with invalid data returns error changeset" do
      survey_response = survey_response_fixture()
      assert {:error, %Ecto.Changeset{}} = Responses.update_survey_response(survey_response, @invalid_attrs)
      assert survey_response == Responses.get_survey_response!(survey_response.id)
    end

    test "delete_survey_response/1 deletes the survey_response" do
      survey_response = survey_response_fixture()
      assert {:ok, %SurveyResponse{}} = Responses.delete_survey_response(survey_response)
      assert_raise Ecto.NoResultsError, fn -> Responses.get_survey_response!(survey_response.id) end
    end

    test "change_survey_response/1 returns a survey_response changeset" do
      survey_response = survey_response_fixture()
      assert %Ecto.Changeset{} = Responses.change_survey_response(survey_response)
    end
  end
end
