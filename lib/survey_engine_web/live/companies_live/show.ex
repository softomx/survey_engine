defmodule SurveyEngineWeb.CompanyLive.Show do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Companies
  alias SurveyEngine.Companies.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:company, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Form registration")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Form registration")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :show, _params) do
    if company_id = socket.assigns.current_user.company_id do
      company =
        Companies.get_company_with_preloads(company_id, [:business_model, :affiliate])
        |> case do
          {:ok, company} -> company
          _ -> %{}
        end

      socket
      |> assign(:page_title, "Empresa")
      |> assign(:company, company)
    else
      socket
      |> push_patch(to: ~p"/company/new")
    end
  end

  @impl true
  def handle_info(
        {SurveyEngineWeb.CompanyLive.FormComponent, {:saved, company}},
        socket
      ) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
end
