defmodule LiuloWeb.UserView do
  use LiuloWeb, :view
  alias LiuloWeb.UserView

  def render("index.json", %{user: user}) do
    %{data: render_many(user, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      full_name: user.full_name,
      email: user.email,
      password: user.password,
      gender: user.gender,
      status: user.status}
  end
end
