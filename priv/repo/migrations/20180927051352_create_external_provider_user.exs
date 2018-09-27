defmodule Liulo.Repo.Migrations.CreateExternalProviderUser do
  use Ecto.Migration

  def change do
    create table(:external_provider_user) do
      add :provider_type, :integer
      add :provider_user_id, :string
      add :data, :map
      add :token, :text
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:external_provider_user, [:user_id])
  end
end
