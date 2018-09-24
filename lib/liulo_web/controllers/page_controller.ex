defmodule LiuloWeb.PageController do
  use LiuloWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
