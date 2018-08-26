defmodule Discuss.User do
  use DiscussWeb, :model
  alias Discuss.{Topic, Comment}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string
    field :github_avatar, :string
    field :provider, :string
    field :token, :string

    has_many :topics, Topic
    has_many :comments, Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(first_name last_name username email github_avatar provider token)a)
    |> validate_required([:email, :provider, :token])
  end
end
