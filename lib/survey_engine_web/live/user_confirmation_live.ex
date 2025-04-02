defmodule SurveyEngineWeb.UserConfirmationLive do
  use SurveyEngineWeb, :live_view

  alias SurveyEngine.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="h-full w-full py-10 px-10">
      <div class="mx-auto max-w-sm">
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800 space-y-5">
          <.header class="text-center">Confirm Account</.header>

          <.form for={@form} id="confirmation_form" phx-submit="confirm_account">
            <input type="hidden" name={@form[:token].name} value={@form[:token].value} viewable />
            <.field type="password" field={@form["password"]} />
            <.field type="password" field={@form["comfirm_password"]} viewable />
            <.button phx-disable-with="Confirming..." class="w-full">Confirm my account</.button>
          </.form>

          <p class="text-center mt-4">
            <.link href={~p"/users/register"}>Register</.link>
            | <.link href={~p"/users/log_in"}>Log in</.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token} = user_params}, socket) do
    case Accounts.confirm_user(token, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
