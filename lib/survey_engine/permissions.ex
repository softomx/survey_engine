defmodule SurveyEngine.Permissions do
  @moduledoc """
  The Permissions context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias SurveyEngine.Accounts
  alias SurveyEngine.Repo

  alias SurveyEngine.Permissions.PermissionAction

  @doc """
  Returns the list of permissions_actions.

  ## Examples

      iex> list_permissions_actions()
      [%PermissionAction{}, ...]

  """
  def list_permissions_actions do
    Repo.all(PermissionAction)
  end

  def list_permissions_actions(args) do
    args
    |> Enum.reduce(PermissionAction, fn
      {:filter, filter}, query ->
        query |> permissions_actions_filter(filter)
    end)
    |> Repo.all()
  end

  def permissions_actions_filter(query, filter) do
    filter
    |> Enum.reduce(query, fn
      {:ids, ids}, query ->
        from q in query, where: q.id in ^ids

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single permission_action.

  Raises `Ecto.NoResultsError` if the Permission action does not exist.

  ## Examples

      iex> get_permission_action!(123)
      %PermissionAction{}

      iex> get_permission_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission_action!(id), do: Repo.get!(PermissionAction, id)

  @doc """
  Creates a permission_action.

  ## Examples

      iex> create_permission_action(%{field: value})
      {:ok, %PermissionAction{}}

      iex> create_permission_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission_action(attrs \\ %{}) do
    %PermissionAction{}
    |> PermissionAction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission_action.

  ## Examples

      iex> update_permission_action(permission_action, %{field: new_value})
      {:ok, %PermissionAction{}}

      iex> update_permission_action(permission_action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission_action(%PermissionAction{} = permission_action, attrs) do
    permission_action
    |> PermissionAction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a permission_action.

  ## Examples

      iex> delete_permission_action(permission_action)
      {:ok, %PermissionAction{}}

      iex> delete_permission_action(permission_action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission_action(%PermissionAction{} = permission_action) do
    Repo.delete(permission_action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission_action changes.

  ## Examples

      iex> change_permission_action(permission_action)
      %Ecto.Changeset{data: %PermissionAction{}}

  """
  def change_permission_action(%PermissionAction{} = permission_action, attrs \\ %{}) do
    PermissionAction.changeset(permission_action, attrs)
  end

  def permissions() do
    SurveyEngineWeb.Router.__routes__()
    |> Enum.filter(&(&1.plug == Phoenix.LiveView.Plug))
    |> Enum.filter(fn live_route ->
        {_module, _action, _router_details, details} = live_route.metadata.phoenix_live_view
        details.extra.on_mount
        |> Enum.any?(fn m ->
            {_conextt, validate_action} = m.id
            validate_action == :validate_route
        end)
    end)
    |> Enum.map(fn live_route ->
      {module, action, _router, _details} = live_route.metadata.phoenix_live_view
      ["Elixir", _project, resource, _action] = String.split("#{module}", ".")
      %{
        path: live_route.path,
        module: module,
        action: Atom.to_string(action),
        resource: resource,
        slug: String.downcase("#{resource}_#{action}")
      }
    end)
  end

  alias SurveyEngine.Permissions.PermissionRoleAction

  @doc """
  Returns the list of permissions_roles_actions.

  ## Examples

      iex> list_permissions_roles_actions()
      [%PermissionRoleAction{}, ...]

  """
  def list_permissions_roles_actions do
    Repo.all(PermissionRoleAction)
  end

  @doc """
  Gets a single permission_role_action.

  Raises `Ecto.NoResultsError` if the Permission role action does not exist.

  ## Examples

      iex> get_permission_role_action!(123)
      %PermissionRoleAction{}

      iex> get_permission_role_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission_role_action!(id), do: Repo.get!(PermissionRoleAction, id)

  @doc """
  Creates a permission_role_action.

  ## Examples

      iex> create_permission_role_action(%{field: value})
      {:ok, %PermissionRoleAction{}}

      iex> create_permission_role_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission_role_action(attrs \\ %{}) do
    %PermissionRoleAction{}
    |> PermissionRoleAction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission_role_action.

  ## Examples

      iex> update_permission_role_action(permission_role_action, %{field: new_value})
      {:ok, %PermissionRoleAction{}}

      iex> update_permission_role_action(permission_role_action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission_role_action(%PermissionRoleAction{} = permission_role_action, attrs) do
    permission_role_action
    |> PermissionRoleAction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a permission_role_action.

  ## Examples

      iex> delete_permission_role_action(permission_role_action)
      {:ok, %PermissionRoleAction{}}

      iex> delete_permission_role_action(permission_role_action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission_role_action(%PermissionRoleAction{} = permission_role_action) do
    Repo.delete(permission_role_action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission_role_action changes.

  ## Examples

      iex> change_permission_role_action(permission_role_action)
      %Ecto.Changeset{data: %PermissionRoleAction{}}

  """
  def change_permission_role_action(
        %PermissionRoleAction{} = permission_role_action,
        attrs \\ %{}
      ) do
    PermissionRoleAction.changeset(permission_role_action, attrs)
  end

  def sync_permissions() do
    Multi.new()
    |> Multi.run(:permissions_actions, fn _repo, _params ->
      {:ok, list_permissions_actions()}
    end)
    |> Multi.run(:new_actions, fn _repo, _params ->
      {:ok, permissions()}
    end)
    |> Multi.run(:root_role, fn _repo, _params ->
      Accounts.get_role_by_slug("root")
    end)
    |> Multi.merge(fn %{
                        permissions_actions: permissions_actions,
                        new_actions: new_actions,
                        root_role: root_role
                      } ->
      new_actions
      |> Enum.with_index()
      |> Enum.reduce(Ecto.Multi.new(), fn {route, index}, multi ->
        multi
        |> Multi.run(String.to_atom("insert_or_get_action_#{index}"), fn _repo, _params ->
          Enum.find(permissions_actions, &(&1.slug == route.slug))
          |> case do
            nil ->
              attrs = %{
                name: route.slug,
                path: route.path,
                action: route.action,
                slug: route.slug,
                resource: route.resource
              }

              create_permission_action(attrs)
              |> case do
                {:ok, local_action} ->
                  create_permission_role_action(%{
                    role_id: root_role.id,
                    permission_action_id: local_action.id
                  })

                error ->
                  error
              end

            local_action ->
              attrs = %{
                path: route.path,
                action: route.action,
                resource: route.resource
              }

              update_permission_action(local_action, attrs)
          end
        end)
      end)
    end)
    |> Repo.transaction()
    |> case do
      {:error, _, reason, _} -> {:error, reason}
      {:ok, _res} -> {:ok, list_permissions_actions()}
    end
  end

  def update_roles_with_actions(attrs) do
    Multi.new()
    |> Multi.run(:roles, fn _repo, _params ->
      {:ok, Accounts.list_roles_with_preloads(:permission_actions)}
    end)
    |> Multi.run(:roles_changes, fn _repo, %{roles: roles} ->
      {:ok, calculate_roles_changes(attrs, roles)}
    end)
    |> Multi.merge(fn %{roles_changes: roles_changes} ->
      roles_changes
      |> Enum.reduce(Ecto.Multi.new(), fn rc, multi ->
        multi
        |> Multi.run(String.to_atom("role_actions_#{rc.role.id}"), fn _repo, _params ->
          application_actions =
            rc.role.permission_actions |> Enum.map(&"#{&1.id}")

          new_actions = list_permissions_actions(%{filter: %{ids: rc.new_actions ++ application_actions}})
          Accounts.update_role_with_actions(rc.role, new_actions)
        end)
      end)
    end)
    |> Repo.transaction()
    |> case do
      {:error, _, reason, _} -> {:error, reason}
      {:ok, _res} -> {:ok, Accounts.list_roles_with_preloads(:permission_actions)}
    end
  end

  defp calculate_roles_changes(attrs, roles) do
    roles
    |> Enum.reduce([], fn role, acc ->
      old_actions = role.permission_actions |> Enum.map(&"#{&1.id}")
      current_attr_role = Enum.find(attrs, %{permission_actions: []}, fn attr -> attr.role_id == "#{role.id}" end)
      new_actions = current_attr_role.actions
      details = List.myers_difference(old_actions, new_actions)

      if is_list(details[:del]) or is_list(details[:ins]) do
        acc ++ [%{role: role, new_actions: new_actions}]
      else
        acc
      end
    end)
  end
end
