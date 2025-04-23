defmodule SurveyEngineWeb.AffiliateLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.AffiliateEngine
  alias SurveyEngine.AffiliateEngine.Affiliate
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [
      :id,
      :inserted_at,
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :company_type
    ],
    filterable: [
      :id,
      :inserted_at,
      :name,
      :affiliate_slug,
      :trading_name,
      :business_name,
      :rfc,
      :company_type
    ]
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
    |> assign(:page_title, "Edit Affiliate")
    |> assign(:affiliate, AffiliateEngine.get_affiliate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Affiliate")
    |> assign(:affiliate, %Affiliate{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Affiliates")
    |> assign_affiliates(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/affiliates?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/affiliates?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    affiliate = AffiliateEngine.get_affiliate!(id)
    {:ok, _} = AffiliateEngine.delete_affiliate(affiliate)

    socket =
      socket
      |> assign_affiliates(socket.assigns.index_params)
      |> put_flash(:info, "Affiliate deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_affiliates(socket, params) do
    starting_query = Affiliate
    {affiliates, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, affiliates: affiliates, meta: meta)
  end
end
