defmodule SurveyEngineWeb.EmbedLive.AgencyDescriptionComponent do
  use SurveyEngineWeb, :live_component

  @impl true
  def update(%{items: items, language: language, glossary_type: glossary_type} = assigns, socket) do
    list_items = list_items_by_language(items, language)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:list_items, list_items)
     |> assign_title_by_type(glossary_type)}
  end

  defp list_items_by_language(list_items, language) do
    Enum.reduce(list_items, [], fn item, acc ->
      description = Enum.find(item.descriptions, fn d -> d.language == language end)
      acc ++ [%{name: item.name, translation: description}]
    end)
  end

  defp get_text_with_locale(locale, funtion) do
    Gettext.with_locale(SurveyEngineWeb.Gettext, locale, fn ->
      funtion
    end)
  end

  defp assign_title_by_type(socket, glossary_type) do
    case glossary_type do
      "agency_type" ->
        socket
        |> assign(
          :title,
          get_text_with_locale(socket.assigns.language, gettext("Description of Agency types"))
        )
        |> assign(
          :subtitle,
          get_text_with_locale(
            socket.assigns.language,
            gettext("Description of the agency types availables")
          )
        )

      "agency_model" ->
        socket
        |> assign(
          :title,
          get_text_with_locale(socket.assigns.language, gettext("Description of agency models"))
        )
        |> assign(
          :subtitle,
          get_text_with_locale(
            socket.assigns.language,
            gettext("Description of the agency models availables")
          )
        )
    end
  end
end
