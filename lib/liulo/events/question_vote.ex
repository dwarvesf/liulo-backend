defmodule Liulo.Events.QuestionVote do
  use Ecto.Schema
  import Ecto.Changeset


  schema "question_vote" do
    # field :question_id, :id
    # field :user_id, :id
    belongs_to(:user, Liulo.Accounts.User)
    belongs_to(:question, Liulo.Events.Question)

    timestamps()
  end

  @doc false
  def changeset(question_vote, attrs) do
    question_vote
    |> cast(attrs, [])
  end
end
