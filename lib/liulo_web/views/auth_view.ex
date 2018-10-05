defmodule LiuloWeb.AuthView do
  use LiuloWeb, :view
  alias LiuloWeb.UserView


  def render("show.json", %{user: user, token: token, claims: _}) do
    %{data: %{
      user: render_one(user, UserView, "user.json"),
      jwt: token
    }}
  end
end
