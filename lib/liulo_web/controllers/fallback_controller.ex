defmodule LiuloWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use LiuloWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(LiuloWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(LiuloWeb.ErrorView, :"404")
  end

  def call(conn, {:error, opts}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(LiuloWeb.ErrorView, "error.json", opts)
  end
end
