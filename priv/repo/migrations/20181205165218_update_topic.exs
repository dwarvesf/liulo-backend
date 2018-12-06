defmodule Liulo.Repo.Migrations.UpdateTopic do
  use Ecto.Migration

  def change do
    alter table(:topic) do
      add :code, :string
    end

    create unique_index(:topic, [:code], name: "topic_code")
  end
end
