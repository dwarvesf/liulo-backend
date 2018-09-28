defmodule Liulo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user" do
    field :email, :string
    field :full_name, :string
    field :gender, GenderEnum
    field :password, :string
    field :status, UserStatusEnum, default: :active

    has_many(:events, Liulo.Events.Event, foreign_key: :owner_id)
    timestamps()
  end

  @required_fields ~w(email full_name)a
  @optional_fields ~w(gender password status)a
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
