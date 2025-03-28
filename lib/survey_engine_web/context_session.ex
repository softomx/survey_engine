defmodule SurveyEngineWeb.ContextSession do
  use SurveyEngineWeb, :verified_routes

  import Phoenix.Controller
  alias SurveyEngine.SiteConfigurations

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """

  def on_mount(:current_page, _params, _session, socket) do
    {:cont,
     socket
     |> Phoenix.LiveView.attach_hook(:current_page, :handle_params, &get_current_page/3)}
  end

  def on_mount(:set_locale, params, session, socket) do
    {:cont,
     socket
     |> Phoenix.Component.assign_new(:locale, fn ->
       locale =
         session["locale"] || locale_from_params(params) || Gettext.get_locale()

       Gettext.put_locale(SurveyEngineWeb.Gettext, locale)
       locale
     end)}
  end

  def on_mount(:load_site_configuration, _params, _session, socket) do
    with {:ok, site_config} <-
           SiteConfigurations.get_site_configuration_by_url(socket.host_uri.host) do
      {:cont,
       socket
       |> Phoenix.Component.assign_new(:site_config, fn -> site_config end)}
    else
      _ ->
        {:halt,
         socket
         |> Phoenix.Component.assign_new(:error, fn -> "Site configuration not found" end)
         |> redirect(to: ~p"/error")}
    end
  end

  defp get_current_page(_params, url, socket) do
    {:cont,
     socket
     |> Phoenix.Component.assign_new(:current_page, fn ->
       %{path: path} = URI.parse(url)
       path
     end)}
  end

  defp locale_from_params(%{"lang" => locale}) do
    locale
  end

  defp locale_from_params(_params) do
    nil
  end
end
