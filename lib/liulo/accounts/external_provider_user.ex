defmodule Liulo.Accounts.ExternalProviderUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "external_provider_user" do
    field(:data, :map)
    field(:provider_type, ProviderTypeEnum, default: :google)
    field(:provider_user_id, :string)
    field(:token, :string)

    belongs_to(:user, Liulo.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(external_provider_user, attrs) do
    external_provider_user
    |> cast(attrs, [:provider_type, :provider_user_id, :data, :token])
    |> validate_required([:provider_type, :provider_user_id, :token])
    |> put_assoc(:user, require: true)
  end
end
