defmodule LiuloWeb.Router do
  use LiuloWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :api_auth do
    plug(Liulo.AuthAccessPipeline)
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", LiuloWeb do
    pipe_through(:api)

    post("/login", AuthController, :callback)
    resources("/topic", TopicController, only: [:show])
    resources("/event", EventController, only: [:show])
    get("/question/guest", QuestionController, :index_guest)
  end

  scope "/api/v1", LiuloWeb do
    pipe_through([:api, :api_auth])

    get("/me", UserController, :me)
    delete("logout", AuthController, :logout)

    resources "/event", EventController, except: [:new, :edit] do
      get("/topic", TopicController, :topic_by_event)
      get("/my_event", EventController, :get_my_event)
      resources "/topic", TopicController, only: [:create]
    end

    resources "/topic", TopicController, except: [:new, :edit] do
      get("/question", QuestionController, :question_by_topic)
      get("/get_my_topic", TopicController, :get_my_topic)
      post("/active", TopicController, :active)
      post("/deactive", TopicController, :deactive)

      resources "/question", QuestionController do
        post("/question_vote", QuestionVoteController, :create)
        post("/question_unvote", QuestionController, :unvote)
        post("/mark_answered", QuestionController, :mark_answered)
        post("/unmark_answered", QuestionController, :unmark_answered)
      end
    end
  end
end
