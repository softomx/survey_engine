defmodule SurveyEngineWeb.PageController do
  use SurveyEngineWeb, :controller

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
