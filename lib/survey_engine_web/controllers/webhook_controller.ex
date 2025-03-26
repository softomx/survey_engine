defmodule SurveyEngineWeb.WebhookController do
  use SurveyEngineWeb, :controller
  alias SurveyEngine.Responses.ResponseProviderBuilder

  def index(
        conn,
        %{"data" => data, "provider" => provider, "site_config" => site_config} = params
      ) do
    case provider do
      "formbricks" ->
        ResponseProviderBuilder.build_response_provider(
          provider,
          site_config,
          data,
          params["event"]
        )
        |> SurveyEngine.Responses.ResponseEngine.process_response()
    end

    conn
    |> json(%{response: "ok"})
  end

  def index(conn, _params) do
    conn
    |> json(%{response: "ok"})
  end
end
