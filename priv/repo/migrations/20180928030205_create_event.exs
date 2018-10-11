defmodule Liulo.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:event) do
      add :code, :string
      add :name, :string
      add :description, :text
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
      add :status, :integer
      add :owner_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:event, [:owner_id])
  end
end
