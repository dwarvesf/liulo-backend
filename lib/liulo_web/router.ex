defmodule LiuloWeb.Router do
  use LiuloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", LiuloWeb do
    pipe_through :api

    resources "/user", UserController, except: [:new, :edit]
  end
end
