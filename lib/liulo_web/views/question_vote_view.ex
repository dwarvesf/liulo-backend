defmodule LiuloWeb.QuestionVoteView do
  use LiuloWeb, :view
  alias LiuloWeb.QuestionVoteView

  def render("index.json", %{question_vote: question_vote}) do
    %{data: render_many(question_vote, QuestionVoteView, "question_vote.json")}
  end

  def render("show.json", %{question_vote: question_vote}) do
    %{data: render_one(question_vote, QuestionVoteView, "question_vote.json")}
  end

  def render("question_vote.json", %{question_vote: question_vote}) do
    %{id: question_vote.id, question: question_vote.id, inserted_at: question_vote.inserted_at}
  end
end
