defmodule SurveyEngineWeb.LeadsFormLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.LeadsForms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.form
        for={@form}
        id="leads_form-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:form_group_id]} type="hidden" value={@form_group_id} />

        <.field
          label_class="capitalize-first-letter"
          field={@form[:language]}
          type="select"
          label={gettext("leads_form.language")}
          options={[{"Español", "es"}, {"Ingles", "en"}]}
        />
        <.field
          label_class="capitalize-first-letter"
          field={@form[:provider]}
          type="select"
          label={gettext("leads_form.provider")}
          options={[{"Formbricks", "formbricks"}]}
        />
        <.field
          label_class="capitalize-first-letter"
          field={@form[:external_id]}
          type="text"
          label={gettext("leads_form.external_id")}
          help_text="Id proporcionado por el proveedor del engine de preguntas"
        />
        <.field
          label_class="capitalize-first-letter"
          field={@form[:active]}
          type="switch"
          label={gettext("leads_form.active")}
        />

        <.button phx-disable-with="Saving...">{gettext("save")}</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{leads_form: leads_form} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(LeadsForms.change_leads_form(leads_form))
     end)}
  end

  @impl true
  def handle_event("validate", %{"leads_form" => leads_form_params}, socket) do
    changeset = LeadsForms.change_leads_form(socket.assigns.leads_form, leads_form_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"leads_form" => leads_form_params}, socket) do
    save_leads_form(socket, socket.assigns.action, leads_form_params)
  end

  defp save_leads_form(socket, :edit, leads_form_params) do
    case LeadsForms.update_leads_form(socket.assigns.leads_form, leads_form_params) do
      {:ok, _leads_form} ->
        {:noreply,
         socket
         |> put_flash(:info, "Leads form updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_leads_form(socket, :new, leads_form_params) do
    case LeadsForms.create_leads_form(leads_form_params) do
      {:ok, _leads_form} ->
        {:noreply,
         socket
         |> put_flash(:info, "Leads form created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
