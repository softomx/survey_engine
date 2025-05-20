defmodule SurveyEngineWeb.FormHelper do
  def list_social_network_options() do
    [
      {"Web", "website"},
      {"Facebook", "facebook"},
      {"Instagram", "instagram"},
      {"Tiktok", "tiktok"}
    ]
  end

  def translate_options(options, locale) do
    options
    |> Enum.map(fn option ->
      translate =
        option.translates
        |> Enum.find(&(&1.language == locale))

      cond do
        Enum.empty?(option.translates) ->
          {option.name, option.name}

        is_nil(translate) ->
          translate =
            option.translates
            |> List.first()

          {translate.description, option.name}

        true ->
          {translate.description, option.name}
      end
    end)
  end
end
