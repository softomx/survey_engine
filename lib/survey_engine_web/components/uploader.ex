defmodule SurveyEngineWeb.UploaderComponent do
  alias SurveyEngine.Responses.SurveyResponseItem
  use SurveyEngineWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:uploaded_files, [])
     |> allow_upload(:resource_media, accept: assigns.accept_file, max_entries: 1)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "save",
        _params,
        %{assigns: %{resource: %SurveyResponseItem{} = survey_response_item}} = socket
      ) do
    consume_uploaded_entries(socket, :resource_media, fn %{path: path}, _entry ->
      url = "virtuallocalfile/#{Ecto.UUID.generate()}"
      file_base64 = path |> File.read!() |> Base.encode64()

      data =
        survey_response_item.answer["data"] ++ [%{"url" => url, "file" => file_base64}]

      case SurveyEngine.Responses.update_survey_response_item(socket.assigns.resource, %{
             "answer" => %{"data" => data}
           }) do
        {:ok, _survey_response_item} ->
          {:ok, path}

        {:error, _error} ->
          {:ok, path}
      end
    end)

    {:noreply,
     socket
     |> assign(:uploaded_files, [])
     |> put_flash(:info, "Respuesta actualizada")
     |> push_navigate(to: socket.assigns.return_to)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, assign(socket, :uploaded_files, [])}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :resource_media, ref)}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <form id="upload-form" phx-submit="save" phx-change="validate" phx-target={@myself}>
        <section phx-drop-target={@uploads.resource_media.ref} class="flex gap-2 mb-2">
          <.card :for={entry <- @uploads.resource_media.entries} variant="outline">
            <.card_content category={""} class="p-3">
              <%= if entry.client_type == "application/pdf" do %>
                <div>
                  <.icon
                    name="hero-document"
                    class="text-primary-700 dark:text-primary-300 w-16 h-16"
                    data-tippy-content={entry.client_name}
                    phx-hook="TippyHook"/>
                  <.badge color="primary" label=".PDF" />
                </div>
              <% else %>
                <.live_img_preview
                  entry={entry}
                  style="width: 150px;height: 150px; margin: 5px; border-radius: 5px;"
                />
              <% end %>
              <div class="flex justify-end ">
                <.button
                  size="xs"
                  type="button"
                  color="danger"
                  class="btn btn-secondary btn-sm"
                  phx-click="cancel-upload"
                  phx-value-ref={entry.ref}
                  phx-target={@myself}
                  aria-label="cancel"
                  label={gettext("remove")}
                />
              </div>
              <p :for={err <- upload_errors(@uploads.resource_media, entry)} class="alert alert-danger">
                {error_to_string(err)}
              </p>
            </.card_content>
          </.card>

          <p :for={err <- upload_errors(@uploads.resource_media)} class="alert alert-danger">
            {error_to_string(err)}
          </p>
        </section>
        <label
          class="cursor-pointer w-full flex items-center justify-center w-full h-80 bg-gray-100 mb-2"
          phx-drop-target={@uploads.resource_media.ref}
        >
          <h3 class="text-muted">{@helper_text}</h3>
          <.live_file_input upload={@uploads.resource_media} class="hidden" />
        </label>
        <.button type="submit" phx-disable-with="Guardando..." label={gettext("upload file")} />
      </form>
    </div>
    """
  end
end
