defmodule Liulo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :full_name, :string
      add :email, :string
      add :password, :string
      add :gender, :integer
      add :status, :integer

      timestamps()
    end

  end
end
