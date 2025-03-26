defmodule SurveyEngine.Responses.ResponseProviderBuilder do
  alias SurveyEngine.Responses.FormBricksResponse

  def build_response_provider(provider, site_config_id, data, event \\ nil) do
    case provider do
      "formbricks" ->
        %FormBricksResponse{data: data, event: event, site_config_id: site_config_id}
    end
  end
end
