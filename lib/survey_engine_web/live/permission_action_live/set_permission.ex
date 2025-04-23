defmodule SurveyEngineWeb.PermissionActionLive.SetPermission do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts
  alias SurveyEngine.Permissions
  alias SurveyEngine.TransaleteHelper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event(
        "set_action",
        %{"action_id" => action_id, "role_id" => role_id, "value" => "on"},
        %{assigns: assigns} = socket
      ) do
    current_rol_permissions = Map.get(assigns.selected_permissions, role_id)

    new_permissions =
      assigns.selected_permissions
      |> Map.put(role_id, current_rol_permissions ++ [action_id])

    {:noreply,
     socket
     |> assign(:selected_permissions, new_permissions)}
  end

  def handle_event(
        "set_action",
        %{"action_id" => action_id, "role_id" => role_id},
        %{assigns: assigns} = socket
      ) do
    current_rol_permissions = Map.get(assigns.selected_permissions, role_id)

    new_permissions =
      assigns.selected_permissions
      |> Map.put(role_id, Enum.reject(current_rol_permissions, &(&1 == action_id)))

    {:noreply,
     socket
     |> assign(:selected_permissions, new_permissions)}
  end

  def handle_event("update_role_actions", _params, %{assigns: assigns} = socket) do
    attrs =
      assigns.selected_permissions
      |> Enum.map(fn {role_id, actions} ->
        %{role_id: role_id, actions: actions}
      end)

    with {:ok, _roles} <- Permissions.update_roles_with_actions(attrs) do
      {:noreply,
       socket
       |> put_flash(:info, "Listado de permisos actualizado correctamente")}
    else
      _error -> {:noreply, socket}
    end
  end

  def handle_event("syn_permissions", _params, %{assigns: _assigns} = socket) do
    with {:ok, _permissions} <- Permissions.sync_permissions() do
      {:noreply,
       socket
       |> put_flash(:info, "Listado de permisos actualizado correctamente")
       |> push_patch(to: ~p"/admin/permissions_actions/set")}
    else
      _error -> {:noreply, socket}
    end
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/permissions_actions/set")}
  end


  defp apply_action(socket, :set_permission , _params) do
    roles = Accounts.list_roles_with_preloads(:permission_actions)

    selected_permissions =
      Enum.reduce(roles, %{}, fn role, acc ->
        Map.put(acc, "#{role.id}", Enum.map(role.permission_actions, &"#{&1.id}"))
      end)

    socket
    |> assign(:permissions, Permissions.list_permissions_actions())
    |> assign(:roles, roles)
    |> assign(:selected_permissions, selected_permissions)
    |> assign(:page_title, "Asignar permisos")
  end

  defp apply_action(socket, :sync_permission, _params) do

    socket
    |> assign(:page_title, "Sincronizar")
  end

  @impl true
  def render(assigns) do
    ~H"""

    <%= if @live_action in [:sync_permission] do %>
      <.modal title={@page_title}>
        <.button color="primary" label="Sincronizar permisos" phx-click="syn_permissions" class="m-2" />
      </.modal>

    <% else %>
    <div class="flex justify-end gap-2 mb-2">
      <.button link_type="live_patch" to={~p"/admin/permissions_actions/sync"} label="Sincronizar permisos"  variant="outline"/>
      <.button color="primary" label="Guardar" phx-click="update_role_actions" />
    </div>
    <div class="lock-header">
      <table class="w-full" >
        <thead>
          <tr>
            <th>Nombre</th>
            <%= for role <- @roles do %>
              <th>{role.name}</th>
            <% end %>
          </tr>
        </thead>
        <tbody>
        <%= for {r, permissions} <- @permissions |> Enum.group_by(fn p -> p.resource end) do %>
          <tr class="bg-gray-200">
            <th class="p-2">
              <p class="text-left text-xs">{TransaleteHelper.permission_resource(r)} </p>
            </th>
            <td colspan={length(@roles)}></td>
          </tr>
          <%= for permission <- permissions do %>
            <tr class="border">
              <th class="p-2 bg-gray-50"
                id={"#{permission.id}"}
                data-tippy-content={"#{permission.path}"}
                phx-hook="TippyHook">
              <p class="text-left text-xs">{TransaleteHelper.permission_action(permission.action)}</p></th>
              <%= for role <- @roles do %>
                <td class="p-2 text-center">
                  <input
                    type="checkbox"
                    class="form-check-input"
                    phx-click="set_action"
                    phx-value-role_id={role.id}
                    phx-value-action_id={permission.id}
                    checked={"#{permission.id}" in Map.get(@selected_permissions, "#{role.id}", [])}
                  />
                </td>
              <% end %>
            </tr>
          <% end %>
        <% end %>
        </tbody>
      </table>
    </div>
    <% end %>
    """
  end
end
