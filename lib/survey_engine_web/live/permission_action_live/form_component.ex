defmodule SurveyEngineWeb.PermissionActionLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Permissions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        id="permission_action-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.field field={@form[:name]} type="text" label={gettext("permission.name")} />
        <.button phx-disable-with="Saving...">{gettext("save")}</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{permission_action: permission_action} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Permissions.change_permission_action(permission_action))
     end)}
  end

  @impl true
  def handle_event("validate", %{"permission_action" => permission_action_params}, socket) do
    changeset = Permissions.change_permission_action(socket.assigns.permission_action, permission_action_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"permission_action" => permission_action_params}, socket) do
    save_permission_action(socket, socket.assigns.action, permission_action_params)
  end

  defp save_permission_action(socket, :edit, permission_action_params) do
    case Permissions.update_permission_action(socket.assigns.permission_action, permission_action_params) do
      {:ok, _permission_action} ->

        {:noreply,
         socket
         |> put_flash(:info, "Permission action updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_permission_action(socket, :new, permission_action_params) do
    case Permissions.create_permission_action(permission_action_params) do
      {:ok, _permission_action} ->

        {:noreply,
         socket
         |> put_flash(:info, "Permission action created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

end
