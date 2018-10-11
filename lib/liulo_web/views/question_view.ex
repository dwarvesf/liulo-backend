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
    %{id: question.id,
      description: question.description,
      vote_count: question.vote_count,
      status: question.status,
      is_anonymous: question.is_anonymous,
      owner_id: question.owner_id}
  end
end
