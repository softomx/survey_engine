defmodule SurveyEngineWeb.EmbedLive.AgencyDescriptionComponent do
  use SurveyEngineWeb, :live_component

  @impl true
  def update(%{agencies: agencies, language: language} = assigns, socket) do
    list_agencies = list_agency_by_language(agencies, language)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:list_agencies, list_agencies)}
  end

  defp list_agency_by_language(list_agencies, language) do
    Enum.reduce(list_agencies, [], fn agency, acc ->
      description = Enum.find(agency.descriptions, fn d -> d.language == language end)
      acc ++ [%{name: agency.name, translation: description}]
    end)
  end

  defp get_text_with_locale(locale, funtion) do
    Gettext.with_locale(SurveyEngineWeb.Gettext, locale, fn ->
      funtion
    end)
  end
end
