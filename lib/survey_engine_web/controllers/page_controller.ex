defmodule SurveyEngineWeb.PageController do
  use SurveyEngineWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def unauthorized(conn, _params) do
    render(conn, :unauthorized, layout: false)
  end
end
