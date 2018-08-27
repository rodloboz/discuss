defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "comments:*", DiscussWeb.CommentsChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} ->
        {:ok, socket}
    end
  end

  def id(_socket), do: nil
end
