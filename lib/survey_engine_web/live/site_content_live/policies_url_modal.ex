defmodule SurveyEngineWeb.SiteContentLive.PoliciesUrlModal do
  alias SurveyEngine.Translations.PolicyForm
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Translations

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-5">
      <.header>
        {gettext("Policie Url")}
      </.header>
      <.form for={@form} id="form_group-form" phx-target={@myself} phx-change="validate">
        <.field type="text" field={@form[:url]} readonly label={gettext("url")}/>
      </.form>

      <div class="flex justify-end">
        <.button
          id="copy-policies-url"
          type="submit"
          phx-disable-with="Copiando..."
          label="Copiar"
          data-clipboard-text={@url}
          phx-hook="Copy"
        />
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    url = url(~p"/policies")

    filter = %PolicyForm{url: url}
    changeset = Translations.change_policy_form(filter)

    {:ok, socket |> assign(assigns) |> assign_form(changeset) |> assign(:url, url)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
