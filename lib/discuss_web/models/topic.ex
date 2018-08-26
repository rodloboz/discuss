defmodule Discuss.Topic do
  use DiscussWeb, :model
  alias Discuss.User

  schema "topics" do
    field :title, :string

    belongs_to :user, User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title user_id)a) # same as %i(title)
    |> validate_required(:title)
  end
end
