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

  pipeline :api_auth do
    plug(Liulo.AuthAccessPipeline)

  end

  # Other scopes may use custom stacks.
  scope "/api/v1", LiuloWeb do
    pipe_through :api

    post "/login_google", AuthController, :callback
    resources "/topic", TopicController, only: [:show] do
    end
    get "/question/guest", QuestionController, :index_guest
  end

  scope "/api/v1", LiuloWeb do
    pipe_through [:api, :api_auth]

    get "/me", UserController, :me

    resources "/event", EventController, except: [:new, :edit] do
      get "/topic", TopicController, :topic_by_event
    end

    resources "/topic", TopicController, except: [:new, :edit] do
      get "/question", QuestionController, :question_by_topic
      resources "/question", QuestionController do
        resources "/question_vote", QuestionVoteController, only: [:delete]
        post "/question_vote", QuestionVoteController, :create
      end
    end
  end

end
