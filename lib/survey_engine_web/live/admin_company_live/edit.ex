defmodule SurveyEngineWeb.AdminCompanyLive.Edit do
  alias SurveyEngine.Accounts
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    list_languages = [%{name: "Español", slug: "es"}, %{name: "Ingles", slug: "en"}]
    company = Companies.get_company!(id)
    {:ok, user} = Accounts.get_user_by_company(id)

    socket
    |> assign(:page_title, "Editar Pre-registro")
    |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
    |> assign(:currencies, Catalogs.list_currencies() |> Enum.map(&{&1.name, &1.slug}))
    |> assign(:agency_types, Catalogs.list_agency_types_with_preload())
    |> assign(:agency_models, Catalogs.list_agency_models_with_preload())
    |> assign(:company, company)
    |> assign(:user, user |> Map.put(:company, company))
    |> assign(:languages, list_languages)
  end

  defp apply_action(socket, :assign_form, %{"id" => id}) do
    socket
    |> assign(:page_title, "Asignar Formulario")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :assign_manager, %{"id" => id}) do
    socket
    |> assign(:page_title, "Asignar Ejecutivo")
    |> assign(:company, Companies.get_company!(id))
  end
end
