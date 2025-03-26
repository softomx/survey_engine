defmodule SurveyEngine.Repo do
  use Ecto.Repo,
    otp_app: :survey_engine,
    adapter: Ecto.Adapters.Postgres
end
