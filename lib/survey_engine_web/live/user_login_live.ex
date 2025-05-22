defmodule SurveyEngineWeb.UserLoginLive do
  alias Phoenix.LiveView.AsyncResult
  alias SurveyEngine.Translations
  use SurveyEngineWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <.header class="text-center text-2xl"></.header>

      <div class="relative  divide-x  py-3 sm:flex sm:flex-row  justify-center bg-transparent ">
        <div>
          <h3 class="text-3xl py-3 font-bold">{gettext("affiliate.program")}</h3>
          <div class="flex-col flex  self-center lg:px-14 sm:max-w-4xl xl:max-w-md  z-10">
            <div class="self-start hidden lg:flex flex-col  text-gray-600">
              <h3 class="my-3 font-semibold text-xl">{gettext("Goals")}</h3>
              <p class="pr-3 text-sm text-gray-500">
                <.async_result :let={goals} assign={@goals}>
                  <:loading>Loading goals...</:loading>
                  <.description
                    description={goals.description}
                    type={goals.content_type}
                    class="prose-sm"
                  />
                </.async_result>
              </p>
            </div>
            <div class="self-start hidden lg:flex flex-col  text-gray-600">
              <h3 class="my-3 font-semibold text-xl">{gettext("Scope")}</h3>
              <p class="pr-3 text-sm text-gray-500">
                <.async_result :let={scopes} assign={@scopes}>
                  <:loading>Loading scopes...</:loading>
                  <.description
                    description={scopes.description}
                    type={scopes.content_type}
                    class="prose-sm"
                  />
                </.async_result>
              </p>
            </div>
            <div class="self-start hidden lg:flex flex-col my-3">
              <.link navigate={~p"/policies"} class="text-md text-primary-700 hover:text-primary-700">
                {gettext("Policies")}
              </.link>
            </div>
          </div>
        </div>
        <div class="flex justify-center self-center  z-10">
          <div class="p-12 bg-white mx-auto rounded-3xl w-96 ">
            <div class="mb-7">
              <h3 class="font-semibold text-2xl text-gray-800">{gettext("Sign In")}</h3>
              <p class="text-gray-400">
                {gettext("Don't have an account?")}
                <.link
                  navigate={~p"/users/register"}
                  class="text-sm text-primary-700 hover:text-primary-700"
                >
                  {gettext("Sign up")}
                </.link>
              </p>
            </div>
            <.form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
              <div class="space-y-6">
                <div class="">
                  <.field
                    label_class="capitalize-first-letter"
                    field={@form[:email]}
                    type="email"
                    label={gettext("Email")}
                    required
                    class="w-full text-sm  px-4 py-3 bg-gray-200 focus:bg-gray-100 border  border-gray-200 rounded-lg focus:outline-none focus:border-primary-400"
                  />
                </div>

                <div class="relative" x-data="{ show: true }">
                  <.field
                    field={@form[:password]}
                    label_class="capitalize-first-letter"
                    type="password"
                    label={gettext("Password")}
                    required
                    viewable
                    class="text-sm text-gray-600 px-4 py-3 rounded-lg w-full bg-gray-200 focus:bg-gray-100 border border-gray-200 focus:outline-none focus:border-primary-400"
                  />
                </div>

                <div class="flex items-center justify-between">
                  <div class="text-sm ml-auto">
                    <.link
                      href={~p"/users/reset_password"}
                      class="text-primary-700 hover:text-primary-600"
                    >
                      {gettext("Forgot your password?")}
                    </.link>
                  </div>
                </div>
                <div>
                  <button
                    type="submit"
                    class="w-full flex justify-center bg-primary-800  hover:bg-primary-700 text-gray-100 p-3  rounded-lg tracking-wide font-semibold  cursor-pointer transition ease-in duration-500"
                  >
                    {gettext("Sign in")}
                  </button>
                </div>
              </div>
            </.form>
          </div>
        </div>
      </div>
    </div>
    <!-- component -->

    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    site_config_id = socket.assigns.site_config.id
    locale = socket.assigns.locale

    socket
    |> assign(:goals, AsyncResult.loading())
    |> assign(:scopes, AsyncResult.loading())
    |> start_async(:get_goals, fn ->
      Translations.get_transalation_by_language_or_default(
        site_config_id,
        "site_configurations",
        "goals",
        locale
      )
    end)
    |> start_async(:get_scopes, fn ->
      Translations.get_transalation_by_language_or_default(
        site_config_id,
        "site_configurations",
        "scopes",
        locale
      )
    end)
  end

  def handle_async(:get_scopes, {:ok, {:ok, fetched_org}}, socket) do
    %{scopes: scopes} = socket.assigns
    {:noreply, assign(socket, :scopes, AsyncResult.ok(scopes, fetched_org))}
  end

  def handle_async(:get_scopes, {:ok, {:error, reason}}, socket) do
    %{scopes: scopes} = socket.assigns
    {:noreply, assign(socket, :scopes, AsyncResult.failed(scopes, {:exit, reason}))}
  end

  def handle_async(:get_goals, {:ok, {:ok, fetched_goals}}, socket) do
    %{goals: goals} = socket.assigns
    {:noreply, assign(socket, :goals, AsyncResult.ok(goals, fetched_goals))}
  end

  def handle_async(:get_goals, {:ok, {:error, reason}}, socket) do
    %{goals: goals} = socket.assigns
    {:noreply, assign(socket, :goals, AsyncResult.failed(goals, {:exit, reason}))}
  end
end
