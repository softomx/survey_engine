defmodule SurveyEngineWeb.AgencyTypeLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Catalogs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.form
        for={@form}
        id="agency_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.field label_class="capitalize-first-letter" field={@form[:name]} type="text" label="Name" />
        <.field
          label_class="capitalize-first-letter"
          field={@form[:active]}
          type="checkbox"
          label="Active"
        />

        <.button phx-disable-with="Saving...">Save Agency type</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{agency_type: agency_type} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalogs.change_agency_type(agency_type))
     end)}
  end

  @impl true
  def handle_event("validate", %{"agency_type" => agency_type_params}, socket) do
    changeset = Catalogs.change_agency_type(socket.assigns.agency_type, agency_type_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"agency_type" => agency_type_params}, socket) do
    save_agency_type(socket, socket.assigns.action, agency_type_params)
  end

  defp save_agency_type(socket, :edit, agency_type_params) do
    case Catalogs.update_agency_type(socket.assigns.agency_type, agency_type_params) do
      {:ok, agency_type} ->
        notify_parent({:saved, agency_type})

        {:noreply,
         socket
         |> put_flash(:info, "Agency type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_agency_type(socket, :new, agency_type_params) do
    case Catalogs.create_agency_type(agency_type_params) do
      {:ok, agency_type} ->
        notify_parent({:saved, agency_type})

        {:noreply,
         socket
         |> put_flash(:info, "Agency type created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
