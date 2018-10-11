defmodule LiuloWeb.QuestionController do
  use LiuloWeb, :controller
  alias Liulo.Events
  alias Liulo.Events.Question
  alias Liulo.Events.Topic
  alias Liulo.Accounts.User

  action_fallback LiuloWeb.FallbackController

  def question_by_topic(conn, %{"topic_id" => id}) do
    topic = Events.get_topic!(id)
    questions = Events.list_question_by_topic(topic) |> Enum.sort_by(fn(p) -> p.vote_count end)
    render(conn, "index.json", question: questions)
  end

  def create(conn, %{"topic_id" => topic_id, "question" => question_params}) do

    with %Topic{} = topic <- Liulo.Repo.get_by!(Topic, id: topic_id),
    %User{} = owner <-  Liulo.Guardian.Plug.current_resource(conn),
        {:ok, %Question{} = question} <- Events.create_question(owner, topic, question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", question_path(conn, :show, question))
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
