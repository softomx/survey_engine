defprotocol SurveyEngine.Responses.ExternalSurveyEngine do
  def process_response(response)

  def build_url_embed_survey(response)

  def get_survey(data)

  def reprocess_all_responses(data)
end

defmodule SurveyEngine.Responses.FormBricks do
  defstruct [:data, :event, :site_config_id]
end

defimpl SurveyEngine.Responses.ExternalSurveyEngine,
  for: SurveyEngine.Responses.FormBricks do
  alias SurveyEngine.Responses.FormbricksEngine
  defdelegate process_response(response), to: FormbricksEngine
  defdelegate build_url_embed_survey(response), to: FormbricksEngine

  defdelegate get_survey(data), to: FormbricksEngine

  defdelegate reprocess_all_responses(data), to: FormbricksEngine
end
