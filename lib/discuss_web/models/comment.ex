defmodule Discuss.Comment do
  use DiscussWeb, :model
  alias Discuss.{User, Topic}

  @derive {Poison.Encoder, only: [:body, :user]}

  schema "comments" do
    field :body, :string

    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(body user_id topic_id)a)
    |> validate_required(:body)
  end
end
