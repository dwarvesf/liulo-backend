defmodule LiuloWeb.TopicChannel do
  use Phoenix.Channel

  alias LiuloWeb.TopicChannel
  alias Liulo.Events
  alias Liulo.Events.Topic

  def join("topic:lobby", _message, socket) do
    IO.puts("joined lobby")

    {:ok, socket}
  end

  def join("topic:" <> topic_id, params, socket) do
    topic = Events.get_topic!(topic_id)
    IO.puts("joined topic #{topic_id}")
    send(self, {:after_join, %{topic_id: topic_id}})
    {:ok, assign(socket, :topic, topic)}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast!(socket, "user:entered", %{user: msg["topic_id"]})
    push(socket, "join", %{status: "connected"})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (user:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_out(Topic, payload, socket) do
    push(socket, Topic, payload)
    {:noreply, socket}
  end

  def broadcast_change(topic_id, event, message, payload) do
    payload = Map.put(payload, "message", message)
    LiuloWeb.Endpoint.broadcast("topic:#{topic_id}", "#{event}", payload)
  end
end
