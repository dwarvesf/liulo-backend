defmodule Liulo.Repo.Migrations.CreateQuestionVote do
  use Ecto.Migration

  def change do
    create table(:question_vote) do
      add :question_id, references(:question, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:question_vote, [:question_id])
    create index(:question_vote, [:user_id])
  end
end
