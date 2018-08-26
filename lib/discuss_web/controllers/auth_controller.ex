defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  require IEx
  # IEx.pry

  # def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
  #   conn
  #   |> put_flash(:error, "Failed to authenticate.")
  #   |> redirect(to: "/")
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    name  = String.split(auth.info.name, " ")
    user_params = %{
      first_name: Enum.at(name, 0),
      last_name: Enum.at(name, -1),
      email: auth.info.email,
      github_avatar: auth.info.image,
      provider: Atom.to_string(auth.provider),
      token: auth.credentials.token
    }
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id) #(:current_user, user)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: "/")
    end

  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
