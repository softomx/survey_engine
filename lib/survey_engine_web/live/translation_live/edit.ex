defmodule SurveyEngineWeb.TranslationLive.Edit do
  alias PetalFramework.Components.DataTable
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Translations
  alias SurveyEngine.Translations.Translation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:index_params, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{
         "id" => id,
         "type" => type,
         "behaviour" => behaviour,
         "resource_id" => resource_id
       }) do
    socket
    |> assign(:page_title, "Edit Translation")
    |> assign(:translation, Translations.get_translation!(id))
    |> assign(:type, type)
    |> assign(:behaviour, behaviour)
    |> assign(:resource_id, resource_id)
  end

  defp build_page_title(%{"type" => type, "behaviour" => behaviour}) do
    cond do
      type == "site_configurations" and behaviour == "goals" ->
        "Objetivos"

      true ->
        ""
    end
  end

  defp build_new_button_text(%{"type" => type, "behaviour" => behaviour}) do
    cond do
      type == "site_configurations" and behaviour == "goals" ->
        "Nuevo objetivo"

      true ->
        ""
    end
  end
end
