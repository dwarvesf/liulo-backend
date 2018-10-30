defmodule LiuloWeb.QuestionController do

  import Ecto.Query
  use LiuloWeb, :controller
  alias Liulo.Events
  alias Liulo.Events.Question
  alias Liulo.Events.Topic
  alias Liulo.Accounts.User
  alias Liulo.Events.QuestionVote
  alias Liulo.Repo

  action_fallback LiuloWeb.FallbackController

  def question_by_topic(conn, %{"topic_id" => id}) do
    owner_id = Liulo.Guardian.Plug.current_resource(conn).id

    topic = Events.get_topic!(id)
    questions = Events.list_question_by_topic(topic) |> Enum.sort_by(fn(p) -> p.vote_count end)

    query = from qv in QuestionVote, where: qv.user_id == ^owner_id
    question_votes = Repo.all(query)

    is_voteds =
      questions
      |> Enum.map(fn(%Question{:id => id}) ->
        question_votes
        |> Enum.filter(
          fn(%QuestionVote{:question_id => question_id}) -> question_id == id end)
        |> Enum.count() > 0
      end)
    render(conn, "is_voted.json", questions: questions, is_votes: is_voteds)
  end

  def create(conn, %{"topic_id" => topic_id, "question" => question_params}) do
    with %Topic{} = topic <- Liulo.Repo.get_by!(Topic, id: topic_id),
          %User{} = owner <-  Liulo.Guardian.Plug.current_resource(conn),
        {:ok, %Question{} = question} <- Events.create_question(owner, topic, question_params) do
      conn
      |> put_status(:created)
      |> render("show.json", question: question)
    end

  end

  def show(conn, %{"id" => id}) do
    question = Events.get_question!(id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Events.get_question!(id)

    with {:ok, %Question{} = question} <- Events.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Events.get_question!(id)
    with {:ok, %Question{}} <- Events.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
