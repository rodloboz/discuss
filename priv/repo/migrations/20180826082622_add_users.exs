defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :email, :string
      add :github_avatar, :string
      add :provider, :string
      add :token, :string

      timestamps()
    end
  end
end
