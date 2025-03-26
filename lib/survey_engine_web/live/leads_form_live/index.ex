defmodule SurveyEngineWeb.LeadsFormLive.Index do
  alias Flop.Meta
  alias PetalFramework.Components.DataTable
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.LeadsForms
  alias SurveyEngine.LeadsForms.LeadsForm

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :date, :state, :data],
    filterable: [:id, :inserted_at, :date, :state, :data]
  ]
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :index_params, nil) |> assign(:meta, %Meta{}) |> assign(:leads_forms, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "form_group_id" => form_group_id}) do
    socket
    |> assign(:page_title, "Edit Leads form")
    |> assign(:leads_form, LeadsForms.get_leads_form!(id))
    |> assign(:form_group_id, form_group_id)
  end

  defp apply_action(socket, :new, %{"form_group_id" => form_group_id} = params) do
    socket
    |> assign(:page_title, "New Leads form")
    |> assign(:leads_form, %LeadsForm{})
    |> assign(index_params: params)
    |> assign(:form_group_id, form_group_id)
  end

  defp apply_action(socket, :index, %{"form_group_id" => form_group_id} = params) do
    socket
    |> assign(:page_title, "Listado de formularios")
    |> assign_survey_responses(params)
    |> assign(index_params: params)
    |> assign(:form_group_id, form_group_id)
  end

  @impl true
  def handle_info({SurveyEngineWeb.LeadsFormLive.FormComponent, {:saved, leads_form}}, socket) do
    {:noreply, stream_insert(socket, :leads_forms, leads_form)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    leads_form = LeadsForms.get_leads_form!(id)
    {:ok, _} = LeadsForms.delete_leads_form(leads_form)

    {:noreply, stream_delete(socket, :leads_forms, leads_form)}
  end

  defp assign_survey_responses(socket, %{"form_group_id" => form_group_id} = params) do
    starting_query = LeadsForms.filter_leads_form(LeadsForm, %{form_group_id: form_group_id})

    {survey_responses, meta} =
      DataTable.search(starting_query, params, @data_table_opts)

    assign(socket, :leads_forms, survey_responses)
    |> assign(:meta, meta)
  end
end
