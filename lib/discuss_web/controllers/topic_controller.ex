defmodule DiscussWeb.TopicController do
  require IEx
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Repo.insert(changeset) do
      {:ok, topic} ->
        redirect(conn, to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", %{
          changeset: changeset,
        })
    end
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
