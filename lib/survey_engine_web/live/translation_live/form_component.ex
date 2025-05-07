defmodule SurveyEngineWeb.TranslationLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Translations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        id="translation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:type]} type="hidden" value={@type} />
        <.input field={@form[:resource_id]} type="hidden" value={@resource_id} />
        <.input field={@form[:behaviour]} type="hidden" value={@behaviour} />
        <.field
          field={@form[:language]}
          type="select"
          label="Language"
          placeholder="Selecciona un lenguage"
          options={[{"Español", "es"}, {"Ingles", "en"}]}
        />
        <%= if @behaviour != "policies" do %>
          <.field
            help_text="Indica si la descipcion es en formato HTML o texto plano"
            field={@form[:content_type]}
            type="select"
            label="Tipo de contenido"
            placeholder="Selecciona un tipo de contenido"
            options={[{"Texto plano", "text_plain"}, {"HTML", "html"}]}
          />
        <% else %>
          <.input field={@form[:content_type]} type="hidden" value={@type_input_text} />
        <% end %>
        <%= if @type_input_text == "html" do %>
          <.field
            field={@form[:description]}
            type="textarea"
            label="Description"
            id={"#{Phoenix.HTML.Form.input_id(@form, :description)}"}
            phx-hook="MarkDownEditor"
          />
        <% else %>
          <.field
            field={@form[:description]}
            type="textarea"
            label="Description"
            id="#form-description"
          />
        <% end %>

        <.button phx-disable-with="Saving...">Guardar</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{translation: translation} = assigns, socket) do
    content_type =
      case assigns.behaviour do
        "policies" -> "html"
        _ -> Map.get(translation, :content_type, "text_plain")
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:type_input_text, content_type)
     |> assign_new(:form, fn ->
       to_form(Translations.change_translation(translation))
     end)}
  end

  @impl true
  def handle_event("validate", %{"translation" => translation_params}, socket) do
    changeset = Translations.change_translation(socket.assigns.translation, translation_params)

    content_type =
      case socket.assigns.behaviour do
        "policies" -> "html"
        _ -> Map.get(translation_params, "content_type", "text_plain")
      end

    {:noreply,
     socket
     |> assign(form: to_form(changeset, action: :validate))
     |> assign(type_input_text: content_type)}
  end

  def handle_event("save", %{"translation" => translation_params}, socket) do
    save_translation(socket, socket.assigns.action, translation_params)
  end

  defp save_translation(socket, :edit, translation_params) do
    case Translations.update_translation(socket.assigns.translation, translation_params) do
      {:ok, _translation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Translation updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_translation(socket, :new, translation_params) do
    case Translations.create_translation(translation_params) do
      {:ok, _translation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Translation created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
