defmodule Liulo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user" do
    field :email, :string
    field :full_name, :string
    field :gender, :integer
    field :password, :string
    field :status, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password, :gender, :status])
    |> validate_required([:full_name, :email, :password, :gender, :status])
  end
end
