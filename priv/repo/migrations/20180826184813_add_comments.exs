defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text, null: false
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end
  end
end
