defmodule SurveyEngineWeb.UserLive.FormRoleComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form :let={f} for={to_form(%{})} id="my-form" phx-target={@myself} phx-submit="save">
          <.field
            type="checkbox-group"
            label="Roles"
            field={f[:role_ids]}
            checked={@selected_roles}
            options={@roles |> Enum.map(fn r -> {r.name, r.id} end)}
          />
        <.button>{gettext("save")}</.button>
    </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    {:ok,
     socket
     |> assign(:roles, Accounts.list_roles())
     |> assign(:selected_roles, Enum.map(user.roles, &("#{&1.id}")))
     |> assign(assigns)}
  end

  @impl true
  def handle_event("save", %{"role_ids" => role_ids}, socket) do
    ids = if is_list(role_ids), do: role_ids, else: []
    roles = Accounts.list_roles(%{filter: %{ids: ids}})
    with {:ok, _user} <- Accounts.update_user_with_roles(socket.assigns.user, roles) do

      {:noreply,
        socket
        |> put_flash(:info, "Roles asignados correctamente")
        |> push_patch(to: socket.assigns.patch)}
    else
      _error ->
        {:noreply, socket}
    end
  end
end
