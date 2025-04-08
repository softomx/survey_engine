defmodule SurveyEngineWeb.UserNotifierView do
  use SurveyEngineWeb, :view
  use Gettext, backend: SurveyEngineWeb.Gettext
  # import Phoenix.HTML

  import SurveyEngineWeb.CoreComponents


  # def translate(language, gettext) do
  #   Gettext.with_locale(
  #     SurveyEngineWeb.Gettext,
  #     language,
  #     fn ->
  #       gettext
  #     end
  #   )
  # end
end
