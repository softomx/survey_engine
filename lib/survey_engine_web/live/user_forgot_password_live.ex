defmodule SurveyEngineWeb.UserForgotPasswordLive do
  alias SurveyEngine.NotificationManager
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts

  def render(assigns) do
    ~H"""
    <div class="h-full w-full py-10 px-10">
      <div class="mx-auto max-w-sm">
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800 space-y-5">
          <.header class="text-center">
            {gettext("title.forgotpassword")}
            <:subtitle>{gettext("subtitle.forgotpassword")}</:subtitle>
          </.header>

          <.form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-5">
            <.input field={@form[:email]} type="email" placeholder="Email" required />

            <.button phx-disable-with="Sending..." class="w-full">
              {gettext("button.sendpasswordresetinstructions")}
            </.button>
          </.form>
          <p class="text-center text-sm mt-4">
            <.link href={~p"/users/register"}>{gettext("register.button.label")}</.link>
            | <.link href={~p"/users/log_in"}>{gettext("login.button.label")}</.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      NotificationManager.resert_password_notification(
        user,
        socket.assigns.site_config,
        socket.assigns.locale,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      gettext(
        "If your email is in our system, you will receive instructions to reset your password shortly."
      )

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
