defmodule SurveyEngineWeb.UserSessionController do
  use SurveyEngineWeb, :controller

  alias SurveyEngine.Accounts
  alias SurveyEngineWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = _params) do
    conn
    |> put_flash(:info, "Revisa tu bandeja de entrada")
    |> redirect(to: ~p"/users/log_in")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      if user.active do
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
      else
        conn
        |> put_flash(:error, gettext("user.inactive.login.message"))
        |> put_flash(:email, String.slice(email, 0, 160))
        |> redirect(to: ~p"/users/log_in")
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, gettext("unser.error.login"))
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
