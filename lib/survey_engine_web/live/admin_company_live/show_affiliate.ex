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
    <div>
      <.page_header title="">
        <.button
          :if={is_nil(@affiliate.external_affiliate_id)}
          label={gettext("create affiliate in gxs")}
          phx-click="create_external_affiliate"
        />
      </.page_header>
      <div class="px-4 sm:px-0">
        <h3 class="text-base/7 font-semibold text-gray-900">{gettext("Affiliate Information")}</h3>
        <p class="mt-1 max-w-2xl text-sm/6 text-gray-500">{gettext("affiliate details")}</p>
      </div>
      <div class="mt-6 border-t border-gray-100">
        <dl class="divide-y divide-gray-100">
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.name")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.name}
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">
              {gettext("affiliate.external_affiliate_id")}
            </dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.external_affiliate_id}
            </dd>
          </div>

          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.slug")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.affiliate_slug}
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.trading_name")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.trading_name}
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.business_name")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.business_name}
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.rfc")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.rfc}
            </dd>
          </div>
          <div class="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
            <dt class="text-sm/6 font-medium text-gray-900">{gettext("affiliate.agency_model")}</dt>
            <dd class="mt-1 text-sm/6 text-gray-700 sm:col-span-2 sm:mt-0">
              {@affiliate.agency_model}
            </dd>
          </div>
        </dl>
      </div>
    </div>
    """
  end
end
