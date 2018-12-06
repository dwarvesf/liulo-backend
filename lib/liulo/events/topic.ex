defmodule Liulo.Events.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic" do
    field(:description, :string)
    field(:ended_at, :naive_datetime)
    field(:name, :string)
    field(:code, :string)
    field(:speaker_names, :string)
    field(:started_at, :naive_datetime)
    field(:status, TopicStatusEnum, default: :active)
    belongs_to(:event, Liulo.Events.Event)
    belongs_to(:owner, Liulo.Accounts.User)

    has_many(:questions, Liulo.Events.Question, foreign_key: :topic_id)

    timestamps()
  end

  @required_fields ~w(name code)a
  @optional_fields ~w(description ended_at speaker_names started_at status)a
  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
