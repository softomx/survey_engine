defmodule SurveyEngineWeb.BusinessConfigLive.Index do
  alias SurveyEngine.LeadsForms
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.BusinessModels
  alias SurveyEngine.BusinessModels.BusinessConfig
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:order, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :order, :previous_lead_form_finished, :form_group_id],
    filterable: [:id, :inserted_at, :order, :previous_lead_form_finished]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "business_model_id" => business_model_id}) do
    socket
    |> assign(:page_title, "Editar asignacion de formulario")
    |> assign(:business_config, BusinessModels.get_business_config!(id))
    |> assign(:business_model_id, business_model_id)
    |> assign(:form_groups, LeadsForms.list_form_groups() |> Enum.map(&{&1.name, &1.id}))
  end

  defp apply_action(socket, :new, %{"business_model_id" => business_model_id}) do
    socket
    |> assign(:page_title, "Asignar nuevo formulario")
    |> assign(:business_config, %BusinessConfig{business_model_id: business_model_id})
    |> assign(:business_model_id, business_model_id)
    |> assign(:form_groups, LeadsForms.list_form_groups() |> Enum.map(&{&1.name, &1.id}))
  end

  defp apply_action(socket, :index, %{"business_model_id" => business_model_id} = params) do
    socket
    |> assign(:page_title, "Listado de formularios asignados")
    |> assign_business_configs(params)
    |> assign(index_params: params)
    |> assign(:business_model_id, business_model_id)
  end

  defp current_index_path(business_model_id, index_params) do
    ~p"/admin/catalogs/business_models/#{business_model_id}/business_configs?#{index_params || %{}}"
  end

  @impl true
  def handle_event(
        "update_filters",
        %{"filters" => filter_params, "business_model_id" => business_model_id},
        socket
      ) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, filter_params)

    {:noreply,
     push_patch(socket,
       to: ~p"/catalogs/business_models/#{business_model_id}/business_configs?#{query_params}"
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    business_config = BusinessModels.get_business_config!(id)
    {:ok, _} = BusinessModels.delete_business_config(business_config)

    socket =
      socket
      |> assign_business_configs(socket.assigns.index_params)
      |> put_flash(:info, "Business config deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply,
     push_patch(socket,
       to: current_index_path(socket.assigns.business_model_id, socket.assigns.index_params)
     )}
  end

  defp assign_business_configs(socket, params) do
    starting_query =
      BusinessModels.business_configs_filter(BusinessConfig, %{
        business_model_id: params["business_model_id"]
      })

    {business_configs, meta} = DataTable.search(starting_query, params, @data_table_opts)

    business_configs =
      business_configs |> BusinessModels.preload_assocs(:form_group) |> find_depend_forms()

    assign(socket, business_configs: business_configs, meta: meta)
  end

  defp find_depend_forms([]), do: []

  defp find_depend_forms(business_configs) do
    ids =
      business_configs
      |> Enum.reduce([], fn i, acc -> acc ++ (i.previous_lead_form_finished || []) end)
      |> Enum.uniq()

    listado = LeadsForms.list_form_groups(%{filter: %{ids: ids}})

    business_configs
    |> Enum.map(fn bc ->
      depend_forms = listado |> Enum.filter(&(&1.id in bc.previous_lead_form_finished))

      bc
      |> Map.put(:depend_forms, depend_forms)
    end)
  end
end
