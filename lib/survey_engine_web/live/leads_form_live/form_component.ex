defmodule SurveyEngineWeb.LeadsFormLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.LeadsForms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage leads_form records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="leads_form-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:form_group_id]} type="hidden" value={@form_group_id} />
        <.field field={@form[:name]} type="text" label="Name" />
        <.field
          field={@form[:language]}
          type="select"
          label="Language"
          options={[{"Español", "es"}, {"Ingles", "en"}]}
        />
        <.field
          field={@form[:provider]}
          type="select"
          label="Proveedor"
          options={[{"Formbricks", "formbricks"}, {"HeyForm", "heyform"}]}
        />
        <.field field={@form[:external_id]} type="text" label="External" />
        <.field field={@form[:active]} type="checkbox" label="Active" />

        <.button phx-disable-with="Saving...">Guardar</.button>
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
      {:ok, leads_form} ->
        # notify_parent({:saved, leads_form})

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
      {:ok, leads_form} ->
        # notify_parent({:saved, leads_form})

        {:noreply,
         socket
         |> put_flash(:info, "Leads form created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
