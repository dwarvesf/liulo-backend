defmodule LiuloWeb.AuthController do
  use LiuloWeb, :controller
  alias Liulo.Accounts
  alias Liulo.Accounts.User

  action_fallback(LiuloWeb.FallbackController)

  def callback(conn, %{"provider" => "google", "access_token" => access_token}) do
    with %GoogleUser{} = google_user <- Google.get_user(access_token),
         %User{} = user <- Accounts.get_user_by_provider("google", google_user) do
      {:ok, token, claims} = Liulo.Guardian.encode_and_sign(user)

      conn
      |> put_status(201)
      |> render("show.json", user: user, token: token, claims: claims)
    end
  end

  def logout(conn, _) do
    conn
    |> Liulo.Guardian.Plug.current_resource(conn)
    |> Liulo.Guardian.revoke()

    send_resp(conn, :no_content, "")
  end
end
