defmodule SurveyEngineWeb.AdminCompanyLive.ShowAffiliate do
  alias SurveyEngine.AffiliateEngine

  use SurveyEngineWeb, :live_view
  alias SurveyEngine.{Companies}
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("create_external_affiliate", _params, socket) do
    with {:ok, external_affiliate_response} <-
           AffiliateEngine.create_external_affiliate(
             socket.assigns.site_config,
             socket.assigns.affiliate
           ),
         {:ok, _affiliate} <-
           AffiliateEngine.update_affiliate(socket.assigns.affiliate, %{
             state: "created",
             external_affiliate_id: "#{external_affiliate_response["data"]["id"]}",
             sync_date: Timex.now(),
             sync_by_id: socket.assigns.current_user.id
           }) do
      socket
      |> put_flash(:info, gettext("affiliate.external_affiliate_created"))
    else
      {:error, reason} ->
        socket
        |> put_flash(:error, reason)
    end

    {:noreply, socket}
  end

  defp apply_action(socket, :show_affiliate, %{"id" => id}) do
    with {:ok, company} <- Companies.get_company_with_preloads(id, :affiliate) do
      socket
      |> assign(:page_title, "#{String.upcase(company.legal_name)}: Afiliado")
      |> assign(:company, company)
      |> assign(:affiliate, %{company.affiliate | company: company})
    else
      _error ->
        socket
        |> assign(:page_title, "")
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-lg">
      <.button
        :if={is_nil(@affiliate.external_affiliate_id)}
        label="Crear afiliado en GXS"
        phx-click="create_external_affiliate"
      />
      <div class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.name")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.name}
          </div>
        </div>
        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.external_affiliate_id")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.external_affiliate_id}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.slug")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.affiliate_slug}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.trading_name")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.trading_name}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.business_name")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.business_name}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.rfc")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.rfc}
          </div>
        </div>

        <div class="sm:col-span-1">
          <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {gettext("affiliate.agency_model")}
          </div>
          <div class="mt-1 text-sm text-gray-900 dark:text-gray-100">
            {@affiliate.agency_model}
          </div>
        </div>
      </div>
    </div>
    """
  end
end
