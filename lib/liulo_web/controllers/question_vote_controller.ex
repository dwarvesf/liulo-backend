defmodule LiuloWeb.QuestionVoteController do
  import Ecto.Query, warn: false

  use LiuloWeb, :controller

  alias Liulo.Events
  alias Liulo.Events.QuestionVote
  alias Liulo.Repo

  action_fallback LiuloWeb.FallbackController

  def create(conn, %{ "question_id" => question_id}) do
    upvote_user = Liulo.Guardian.Plug.current_resource(conn)
    question = Events.get_question!(question_id)
    query = from qv in QuestionVote, where: qv.user_id == ^upvote_user.id and qv.question_id == ^question.id
    existed = Repo.all(query) |> Enum.count > 0

    if existed == false do
      with {:ok, %QuestionVote{} = _} <- Events.create_question_vote(question, upvote_user) do

        #update count field of question table
        update_number_of_vote_for_question(question)
        json(conn, %{"message" => "ok"})
      end
    else
      send_resp(conn, 500, "You are already vote for this question")
    end
  end

  defp update_number_of_vote_for_question(question) do
    query = from qv in QuestionVote, where: qv.question_id == ^question.id
    with count <- Repo.all(query) |> Enum.count do
      Events.update_question(question, %{vote_count: count})

    end
  end


  def delete(conn, %{ "question_id" => question_id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    with Events.delete_question_vote(question_id, user.id) do
     send_resp(conn, :no_content, "")
    end
  end
end
