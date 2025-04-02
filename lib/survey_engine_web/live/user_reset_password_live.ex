defmodule SurveyEngineWeb.UserResetPasswordLive do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts

  def render(assigns) do
    ~H"""
    <div class="h-full w-full py-10 px-10">
      <div class="mx-auto max-w-sm">
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800 space-y-5">
          <.form
            for={@form}
            id="reset_password_form"
            phx-submit="reset_password"
            phx-change="validate"
          >
            <.field field={@form[:password]} type="password" label="New password" required />
            <.field
              field={@form[:password_confirmation]}
              type="password"
              label="Confirm new password"
              required
            />

            <.button phx-disable-with="Resetting..." class="w-full">Reset Password</.button>
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

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
