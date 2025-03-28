defmodule SurveyEngineWeb.UserLoginLive do
  alias SurveyEngine.Translations
  use SurveyEngineWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <.header class="text-center text-2xl"></.header>

      <div class="relative  divide-x  py-3 sm:flex sm:flex-row  justify-center bg-transparent ">
        <div>
          <h3 class="text-3xl py-3 font-bold">{gettext("Programa de afiliados")}</h3>
          <div class="flex-col flex  self-center lg:px-14 sm:max-w-4xl xl:max-w-md  z-10">
            <div class="self-start hidden lg:flex flex-col  text-gray-600">
              <h3 class="my-3 font-semibold text-xl">{gettext("Goals")}</h3>
              <p class="pr-3 text-sm text-gray-500">
                {@goals.description}
              </p>
            </div>
            <div class="self-start hidden lg:flex flex-col  text-gray-600">
              <h3 class="my-3 font-semibold text-xl">{gettext("Scope")}</h3>
              <p class="pr-3 text-sm text-gray-500">
                {@scopes.description}
              </p>
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
    with {:ok, translate} <-
           Translations.get_transalation_by_language_or_default(
             socket.assigns.site_config.id,
             "site_configurations",
             "goals",
             socket.assigns.locale
           ),
         {:ok, translate} <-
           Translations.get_transalation_by_language_or_default(
             socket.assigns.site_config.id,
             "site_configurations",
             "scopes",
             socket.assigns.locale
           ) do
      socket
      |> assign(:goals, translate)
      |> assign(:scopes, translate)
    end
  end
end
