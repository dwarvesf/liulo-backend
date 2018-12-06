defmodule LiuloWeb.QuestionView do
  use LiuloWeb, :view
  alias LiuloWeb.QuestionView

  def render("index.json", %{question: question}) do
    %{data: render_many(question, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      description: question.description,
      vote_count: question.vote_count,
      status: question.status,
      is_anonymous: question.is_anonymous,
      owner_id: question.owner_id,
      owner: render_one(question.owner, LiuloWeb.UserView, "user.json"),
      question_votes:
        render_many(question.question_votes, LiuloWeb.QuestionVoteView, "question_vote.json")
    }
  end

  def render("is_voted.json", %{questions: questions, is_votes: is_votes}) do
    questions
    |> Enum.with_index()
    |> Enum.map(fn {q, idx} ->
      is_vote = Enum.at(is_votes, idx)

      %{
        id: q.id,
        description: q.description,
        vote_count: q.vote_count,
        status: q.status,
        is_anonymous: q.is_anonymous,
        owner_id: q.owner_id,
        is_voted: is_vote
      }
    end)
  end
end
