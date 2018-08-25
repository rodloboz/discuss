defmodule Discuss.Topic do
  use DiscussWeb, :model

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title)a) # same as %i(title)
    |> validate_required(:title)
  end
end
