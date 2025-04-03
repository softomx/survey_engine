defmodule SurveyEngine.TransaleteHelper do
  use Gettext, backend: SurveyEngineWeb.Gettext

  def survey_response_state(state) do
    case state do
      "finished" -> gettext("survey_response.finished")
      "updated" -> gettext("survey_response.updated")
      "pending" -> gettext("survey_response.pending")
      "info_error" -> gettext("survey_response.info_error")
      "init" -> gettext("survey_response.init")
      _ -> state
    end
  end

  def list_survey_response_states() do
    ["pending", "updated", "finished", "info_error"]
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
