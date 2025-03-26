defprotocol SurveyEngine.Responses.ResponseEngine do
  def process_response(response)

  def build_url_embed_survey(response)

  def get_survey(data)
end

defmodule SurveyEngine.Responses.FormBricksResponse do
  defstruct [:data, :event, :site_config_id]
end

defimpl SurveyEngine.Responses.ResponseEngine, for: SurveyEngine.Responses.FormBricksResponse do
  alias SurveyEngine.Responses.FormbricksEngine
  defdelegate process_response(response), to: FormbricksEngine
  defdelegate build_url_embed_survey(response), to: FormbricksEngine

  defdelegate get_survey(data), to: FormbricksEngine
end
