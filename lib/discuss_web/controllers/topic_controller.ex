defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  # defp render_form(conn, action, announcement) do
  #   changeset = Announcement.create_changeset(announcement, %{})
  #   interests = Repo.all(Interest)
  #   users = Repo.all(User.active)

  #   render(conn, action, %{
  #     changeset: changeset,
  #     interests: interests,
  #     users: users,
  #   })
  # end
end
