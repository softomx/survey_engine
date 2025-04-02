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
            Forgot your password?
            <:subtitle>We'll send a password reset link to your inbox</:subtitle>
          </.header>

          <.form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-5">
            <.input field={@form[:email]} type="email" placeholder="Email" required />

            <.button phx-disable-with="Sending..." class="w-full">
              Send password reset instructions
            </.button>
          </.form>
          <p class="text-center text-sm mt-4">
            <.link href={~p"/users/register"}>Register</.link>
            | <.link href={~p"/users/log_in"}>Log in</.link>
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
        &url(~p"/users/reset_password/#{&1}")
      )

      # Accounts.deliver_user_reset_password_instructions(
      #   user,
      #   &url(~p"/users/reset_password/#{&1}")
      # )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
