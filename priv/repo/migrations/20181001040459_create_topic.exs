defmodule Liulo.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topic) do
      add :name, :string
      add :description, :string
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
      add :speaker_names, :string
      add :status, :integer
      add :event_id, references(:event, on_delete: :nothing)
      add :owner_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:topic, [:event_id])
    create index(:topic, [:owner_id])
  end
end
