defmodule SurveyEngine.PermissionManager do
  alias SurveyEngine.Accounts.User
  use SurveyEngineWeb, :verified_routes

  def authorize_user?(%User{} = current_user, %{path: path}) do
    get_user_permissions(current_user)
    |> validate_result(fn permission -> permission.path == path end)
  end

  def authorize_user?(%User{} = _current_user, _params), do: false

  defp get_user_permissions(current_user) do
    current_user.roles
    |> Enum.map(fn role -> role.permission_actions end)
    |> List.flatten()
  end

  defp validate_result(permissions, find_fn) do
    permissions
    |> Enum.find(fn permission ->
      find_fn.(permission)
    end)
    |> case do
      nil -> false
      _permission -> true
    end
  end

  def map_menu(current_user) do
    []
    |> map_menu_group(current_user, :client)
    |> map_menu_group(current_user, :forms)
    |> map_menu_group(current_user, :admin)
    |> map_menu_group(current_user, :reports)
    |> map_menu_group(current_user, :catalogs)
    |> map_menu_group(current_user, :sites)


  end

  def map_menu_group(base_menu, current_user, :client) do
    [
      %{
        name: ~p"/dashboard",
        label: "Dashboard",
        path: ~p"/dashboard",
        icon: "hero-building-library"
      },
      %{
        name: ~p"/company",
        label: "Empresa",
        path: ~p"/company",
        icon: "hero-building-library"
      }
    ]
    |> validate_items(current_user, "Cliente", base_menu)
  end

  def map_menu_group(base_menu, current_user, :forms) do
    [
      %{
        name: ~p"/admin/form_groups",
        label: "Formularios",
        path: ~p"/admin/form_groups",
        icon: "hero-question-mark-circle"
      },
      %{
        name: ~p"/admin/catalogs/business_models",
        label: "Modelos de negocio",
        path: ~p"/admin/catalogs/business_models",
        icon: "hero-user"
      }
    ]
    |> validate_items(current_user, "Formularios", base_menu)
  end


  def map_menu_group(base_menu, current_user, :admin) do
    [
      %{
        name: ~p"/admin/companies",
        label: "Empresas",
        path: ~p"/admin/companies",
        icon: "hero-building-office-2"
      },
      %{
        name: ~p"/admin/survey_answers",
        label: "Respuestas",
        path: ~p"/admin/survey_answers",
        icon: "hero-clipboard-document-list"
      },
      %{
        name: ~p"/admin/roles",
        label: "Roles",
        path: ~p"/admin/roles",
        icon: "hero-user"
      },
      %{
        name: ~p"/admin/permissions_actions/set",
        label: "Asignar Permisos",
        path: ~p"/admin/permissions_actions/set",
        icon: "hero-user"
      }
    ]
    |> validate_items(current_user, "Admin", base_menu)
  end

  def map_menu_group(base_menu, current_user, :reports) do
    [
      %{
        name: ~p"/admin/reports/pre_registration",
        label: "Pre-registro",
        path: ~p"/admin/reports/pre_registration",
        icon: "hero-document-magnifying-glass"
      },
      %{
        name: ~p"/admin/reports/response",
        label: "General",
        path: ~p"/admin/reports/response",
        icon: "hero-document-magnifying-glass"
      }
    ]
    |> validate_items(current_user, "Reportes", base_menu)
  end

  def map_menu_group(base_menu, current_user, :catalogs) do
    [
      %{
        name: ~p"/admin/catalogs/currencies",
        label: "Monedas",
        path: ~p"/admin/catalogs/currencies",
        icon: "hero-currency-dollar"
      },
      %{
        name: ~p"/admin/catalogs/agency_types",
        label: "Tipos de agencia",
        path: ~p"/admin/catalogs/agency_types",
        icon: "hero-user"
      },
      %{
        name: ~p"/admin/catalogs/personal_titles",
        label: "Titulos personales",
        path: ~p"/admin/catalogs/personal_titles",
        icon: "hero-user"
      }
    ]
    |> validate_items(current_user, "Catalogos", base_menu)
  end

  def map_menu_group(base_menu, current_user, :sites) do
    [
      %{
        name: ~p"/admin/site_configurations",
        label: "Sitios",
        path: ~p"/admin/site_configurations",
        icon: "hero-globe-alt"
      },
      %{
        name: ~p"/admin/content/scopes",
        label: "Alcances",
        path: ~p"/admin/content/scopes",
        icon: "hero-document-arrow-up"
      },
      %{
        name: ~p"/admin/content/policies",
        label: "Politicas",
        path: ~p"/admin/content/policies",
        icon: "hero-document-text"
      },
      %{
        name: ~p"/admin/content/goals",
        label: "Objetivos",
        path: ~p"/admin/content/goals",
        icon: "hero-document-check"
      },
      %{
        name: ~p"/admin/mailer_config",
        label: "Configuracion Correo",
        path: ~p"/admin/mailer_config",
        icon: "hero-envelope"
      },
      %{
        name: ~p"/admin/notifications",
        label: "Configuracion de Notificaciones",
        path: ~p"/admin/notifications",
        icon: "hero-bell-alert"
      }
    ]
    |> validate_items(current_user, "Sitios", base_menu)
  end

  defp validate_items(menu_items, current_user, title, base_menu) do
    menu_items =
      menu_items
      |> Enum.filter(fn item ->
        authorize_user?(current_user, %{path: item.path})
      end)

    if length(menu_items) > 0 do
      base_menu ++ [%{title: title, menu_items: menu_items}]
    else
      base_menu
    end
  end
end
