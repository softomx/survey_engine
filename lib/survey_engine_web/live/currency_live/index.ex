defmodule SurveyEngineWeb.CurrencyLive.Index do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Catalogs
  alias SurveyEngine.Catalogs.Currency
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at],
    filterable: [:id, :inserted_at]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:index_params, nil)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Moneda")
    |> assign(:currency, Catalogs.get_currency!(id))
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, "Nueva Moneda")
    |> assign(:currency, %Currency{})
    |> assign(:index_params, params)
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listado de Monedas")
    |> assign_currencies(params)
    |> assign(:index_params, params)
  end

  @impl true
  def handle_info({SurveyEngineWeb.CurrencyLive.FormComponent, {:saved, currency}}, socket) do
    {:noreply, stream_insert(socket, :currencies, currency)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    currency = Catalogs.get_currency!(id)
    {:ok, _} = Catalogs.delete_currency(currency)

    {:noreply, stream_delete(socket, :currencies, currency)}
  end

  defp assign_currencies(socket, params) do
    starting_query = Catalogs.Currency
    {currencies, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, currencies: currencies, meta: meta)
  end
end
