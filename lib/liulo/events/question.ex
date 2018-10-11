defmodule Liulo.Events.Question do
  use Ecto.Schema
  import Ecto.Changeset


  schema "question" do
    field :description, :string
    field :is_anonymous, :boolean, default: false
    field :status, QuestionStatusEnum, default: :pending
    field :vote_count, :integer , default: 0
    # field :owner_id, :id
    # field :topic_id, :id
    belongs_to(:owner, Liulo.Accounts.User)
    belongs_to(:topic, Liulo.Events.Topic)

    timestamps()
  end
  @required_fields ~w(description is_anonymous)a
  @optional_fields ~w(status vote_count)a

  @vote_field ~w(vote_count)a
  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def up_down_vote_chageset(question , attrs) do
    question
    |> cast(attrs, @vote_field)
  end
end
