defmodule Liulo.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:question) do
      add :description, :string
      add :vote_count, :integer
      add :status, :integer
      add :is_anonymous, :boolean, default: false, null: false
      add :owner_id, references(:user, on_delete: :nothing)
      add :topic_id, references(:topic, on_delete: :nothing)

      timestamps()
    end

    create index(:question, [:owner_id])
    create index(:question, [:topic_id])
  end
end
