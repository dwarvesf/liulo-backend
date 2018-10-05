defmodule LiuloWeb.TopicController do
  use LiuloWeb, :controller

  alias Liulo.Events
  alias Liulo.Events.Topic
  alias Liulo.Events.Event
  alias Liulo.Accounts.User

  action_fallback LiuloWeb.FallbackController

  def create(conn, %{"id" => id, "topic" => topic_params}) do
    with %Event{} = event <-  Liulo.Repo.get_by!(Event, id: id),
    %User{} = owner <-  Liulo.Guardian.Plug.current_resource(conn),
    {:ok, %Topic{} = topic} <- Events.create_topic(event, owner, topic_params) do

      conn
      |> put_status(:created)
      |> put_resp_header("location", topic_path(conn, :show, topic))
      |> render("show.json", topic: topic)
    end
  end

  def topic_by_event(conn, %{"event_id" => id}) do
    with %Event{} = event <-  Liulo.Repo.get_by!(Event, id: id),
      topics = Events.list_topic_by_event(event)  do
        conn
        |> render("index.json", topic: topics)

    end
  end




  def show(conn, %{"id" => id}) do
    topic = Events.get_topic!(id)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Events.get_topic!(id)

    with {:ok, %Topic{} = topic} <- Events.update_topic(topic, topic_params) do
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Events.get_topic!(id)
    with {:ok, %Topic{}} <- Events.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
