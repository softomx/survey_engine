defmodule SurveyEngine.TransaleteHelper do
  use Gettext, backend: SurveyEngineWeb.Gettext

  def survey_response_state(state) do
    case state do
      "finished" -> gettext("survey_response.finished")
      "updated" -> gettext("survey_response.updated")
      "pending" -> gettext("survey_response.pending")
      "rejected" -> gettext("survey_response.rejected")
      "approved" -> gettext("survey_response.approved")
      "init" -> gettext("survey_response.init")
      _ -> state
    end
  end

  def survey_response_review_state(state) do
    case state do
      "pending" -> gettext("survey_response_review.pending")
      "approved" -> gettext("survey_response_review.approved")
      "rejected" -> gettext("survey_response_review.rejected")
      _ -> state
    end
  end

  def list_survey_response_states() do
    ["pending", "updated", "finished", "rejected", "approved"]
    |> Enum.map(fn state ->
      {survey_response_state(state), state}
    end)
  end

  def list_languages() do
    [{language("es"), "es"}, {language("en"), "en"}]
  end

  def language(language) do
    case language do
      "es" ->
        "Español"

      "en" ->
        "Ingles"
    end
  end
end
