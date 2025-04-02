defmodule SurveyEngine.TransaleteHelper do
  use Gettext, backend: SurveyEngineWeb.Gettext

  def survey_response_state(state) do
    case state do
      "finished" -> gettext("survey_response.finished")
      "updated" -> gettext("survey_response.updated")
      "init" -> gettext("survey_response.init")
      _ -> state
    end
  end

end
