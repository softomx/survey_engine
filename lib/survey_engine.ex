defmodule SurveyEngine do
  @moduledoc """
  SurveyEngine keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def format_date(date, format \\ "{0D}/{0M}/{YYYY}") do
    Timex.format!(date, format)
  end

  def to_timezone(datetime) do
    Timex.to_datetime(datetime)
    |> Timex.to_datetime("America/Cancun")
    |> Timex.format!("{0D}-{0M}-{YYYY} {h24}:{m}:{s}")
  end
end
