defmodule DiscussWeb.TopicController do
  require IEx
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  require IEx

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    topic_params = topic_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Topic.changeset(%Topic{}, topic_params)

    # changeset = conn.assigns.current_user
    #   |> Repo.build_assoc(:topics)
    #   |> Topic.changeset(topic_params)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |>redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not Save Topic")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Saved")
        |>redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not Save Topic")
        |> render("edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Repo.get(Topic, id).user_id == conn.assigns.current_user.id do
      conn
    else
      conn
      |> put_flash(:error, "You don't have permission to do that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
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
