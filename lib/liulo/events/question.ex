defmodule Liulo.Events.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question" do
    field(:description, :string)
    field(:is_anonymous, :boolean, default: false)
    field(:status, QuestionStatusEnum, default: :active)
    field(:vote_count, :integer, default: 0)
    belongs_to(:owner, Liulo.Accounts.User)
    belongs_to(:topic, Liulo.Events.Topic)

    has_many(:question_votes, Liulo.Events.QuestionVote, on_delete: :delete_all)
    timestamps()
  end

  @required_fields ~w(description)a
  @optional_fields ~w(status vote_count is_anonymous)a
  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
