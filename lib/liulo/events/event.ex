defmodule Liulo.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "event" do
    field :code, :string
    field :description, :string
    field :ended_at, :naive_datetime
    field :name, :string
    field :started_at, :naive_datetime
    field :status, EventStatusEnum, default: :active
    # field :owner_id, :integer

    belongs_to(:owner, Liulo.Accounts.User)
    timestamps()
  end
  @required_fields ~w(code name)a
  @optional_fields ~w(description ended_at started_at status)a
  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
