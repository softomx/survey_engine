defmodule SurveyEngineWeb.FormGroupLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.LeadsForms
  alias SurveyEngine.LeadsForms.FormGroup
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :name],
    filterable: [:id, :inserted_at, :name]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Formulario")
    |> assign(:form_group, LeadsForms.get_form_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nuevo formulario")
    |> assign(:form_group, %FormGroup{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listado de formularios")
    |> assign_form_groups(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/admin/form_groups?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", %{"filters" => filter_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/form_groups?#{filter_params}")}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_form_groups(socket, params) do
    starting_query = FormGroup
    {form_groups, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, form_groups: form_groups, meta: meta)
  end
end
