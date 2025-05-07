defmodule SurveyEngineWeb.UserLive.FormRoleComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        :let={f}
        for={@form}
        phx-change="validate"
        id="my-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.field type="text" label="Nombre" field={f[:name]} required />
        <.field type="text" label="Correo electronico" field={f[:email]} required />
        <.field
          type="checkbox-group"
          label="Roles"
          field={f[:role_ids]}
          checked={@selected_roles}
          options={@roles |> Enum.map(fn r -> {r.name, r.id} end)}
        />

        <.field
          :if={@action == :new}
          type="password"
          label="contraseña"
          field={f[:password]}
          required
        />
        <.button>{gettext("save")}</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user_registration(user)

    {:ok,
     socket
     |> assign(:roles, Accounts.list_roles())
     |> assign(:selected_roles, Enum.map(user.roles, &"#{&1.id}"))
     |> assign(assigns)
     |> assign(:form, to_form(changeset, as: "user"))}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    save(socket, socket.assigns.action, user_params)
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(socket.assigns.user, user_params)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  defp save(socket, :new, user_params) do
    ids = if is_list(user_params["role_ids"]), do: user_params["role_ids"], else: []
    roles = Accounts.list_roles(%{filter: %{ids: ids}})

    case Accounts.register_user(user_params, roles) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Usuario creado correctamente")
         |> push_navigate(to: ~p"/admin/users")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save(socket, _, user_params) do
    ids = if is_list(user_params["role_ids"]), do: user_params["role_ids"], else: []
    roles = Accounts.list_roles(%{filter: %{ids: ids}})

    with {:ok, _user} <- Accounts.update_user_with_roles(socket.assigns.user, user_params, roles) do
      {:noreply,
       socket
       |> put_flash(:info, "Usuario actualizado correctamente")
       |> push_patch(to: socket.assigns.patch)}
    else
      _error ->
        {:noreply, socket}
    end
  end
end
