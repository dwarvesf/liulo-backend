defmodule LiuloWeb.QuestionVoteController do
  import Ecto.Query, warn: false

  use LiuloWeb, :controller

  alias Liulo.Events
  alias Liulo.Events.QuestionVote
  alias Liulo.Repo

  action_fallback(LiuloWeb.FallbackController)

  def create(conn, %{"topic_id" => topic_id, "question_id" => question_id}) do
    upvote_user = Liulo.Guardian.Plug.current_resource(conn)
    question = Events.get_question!(question_id)
    existed = Repo.get_by(QuestionVote, user_id: upvote_user.id, question_id: question.id) != nil

    if existed == false do
      with {:ok, %{question_vote: question_vote}} <-
             Events.create_question_vote(question, upvote_user) do
        Liulo.Notifications.notify_when_upvote_question(topic_id, %{
          question_id: question_id,
          user_id: upvote_user.id,
          full_name: upvote_user.full_name
        })

        render(conn, "show.json", question_vote: question_vote)
      end
    else
      send_resp(conn, 500, "You are already vote for this question")
    end
  end

  def delete(conn, %{"question_id" => question_id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    question = Events.get_question!(question_id)

    with Events.delete_question_vote(question, user.id) do
      send_resp(conn, :no_content, "")
    end
  end
end
