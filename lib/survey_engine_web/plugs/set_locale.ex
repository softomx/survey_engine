defmodule SurveyEngineWeb.Plugs.Locale do
  import Plug.Conn

  @locales ["en", "es"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    Gettext.put_locale(SurveyEngineWeb.Gettext, loc)

    conn
    |> assign(:locale, loc)
    |> put_session(:locale, loc)
  end

  def call(conn, default) do
    if locale = Plug.Conn.get_session(conn, :locale) do
      Gettext.put_locale(SurveyEngineWeb.Gettext, locale)
      conn
    else
      Gettext.put_locale(SurveyEngineWeb.Gettext, default)

      conn
      |> assign(:locale, default)
      |> put_session(:locale, default)
    end
  end
end
