defmodule SurveyEngineWeb.RoleLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        id="role-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.field field={@form[:name]} type="text" label={gettext("role.name")} />
        <.field field={@form[:slug]} type="text" label={gettext("role.slug")} />

        <.button phx-disable-with="Saving...">{gettext("save")}</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{role: role} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_role(role))
     end)}
  end

  @impl true
  def handle_event("validate", %{"role" => role_params}, socket) do
    changeset = Accounts.change_role(socket.assigns.role, role_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"role" => role_params}, socket) do
    save_role(socket, socket.assigns.action, role_params)
  end

  defp save_role(socket, :edit, role_params) do
    case Accounts.update_role(socket.assigns.role, role_params) do
      {:ok, _role} ->

        {:noreply,
         socket
         |> put_flash(:info, "Role updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_role(socket, :new, role_params) do
    case Accounts.create_role(role_params) do
      {:ok, _role} ->

        {:noreply,
         socket
         |> put_flash(:info, "Role created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
