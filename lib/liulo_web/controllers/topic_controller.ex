defmodule LiuloWeb.TopicController do
  use LiuloWeb, :controller

  alias Liulo.Event
  alias Liulo.Repo
  alias Liulo.Events
  alias Liulo.Events.Topic
  alias Liulo.Events.Event
  alias Liulo.Accounts.User

  action_fallback(LiuloWeb.FallbackController)

  def create(conn, %{"id" => id, "topic" => topic_params}) do
    with %Event{} = event <- Repo.get_by!(Event, id: id),
         %User{} = owner <- Liulo.Guardian.Plug.current_resource(conn),
         {:ok, %Topic{} = topic} <- Events.create_topic(event, owner, topic_params) do
      topic = Events.get_topic_by_code!(topic.code, owner)

      conn
      |> put_status(:created)
      |> put_resp_header("location", topic_path(conn, :show, topic))
      |> render("show.json", topic: topic)
    end
  end

  def create(conn, %{"event_id" => id, "topic" => topic_params}) do
    with %Event{} = event <- Repo.get_by!(Event, id: id),
         %User{} = owner <- Liulo.Guardian.Plug.current_resource(conn),
         {:ok, %Topic{} = topic} <- Events.create_topic(event, owner, topic_params) do
      topic = Events.get_topic_by_code!(topic.code, owner)

      conn
      |> put_status(:created)
      |> put_resp_header("location", topic_path(conn, :show, topic))
      |> render("show.json", topic: topic)
    end
  end

  def topic_by_event(conn, %{"event_id" => id}) do
    with %Event{} = event <- Repo.get_by!(Event, id: id),
         topics = Events.list_topic_by_event(event) do
      conn
      |> render("index.json", topic: topics)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    topic = Events.get_topic_by_code!(id, user)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Events.get_topic!(id)
    user = Liulo.Guardian.Plug.current_resource(conn)

    with {:ok, %Topic{} = topic} <- Events.update_topic(topic, topic_params) do
      topic = Events.get_topic_by_code!(topic.code, user)
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Events.get_topic!(id)

    with {:ok, %Topic{}} <- Events.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_my_topic(conn, %{"topic_id" => id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)

    with %Topic{} = topic <- Repo.get_by(Topic, code: id, owner_id: user.id),
         topic <- topic |> Repo.preload([questions: :owner, questions: :question_votes]) do
      render(conn, "show.json", topic: topic)
    end
  end

  def active(conn, %{"topic_id" => id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    topic = Events.get_topic_by_event_owner!(id, user)
    with {:ok, _} <- Events.update_topic(topic, %{status: :active}) do
      send_resp(conn, :no_content, "")
    end
  end

  def deactive(conn, %{"topic_id" => id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    topic = Events.get_topic_by_event_owner!(id, user)
    with {:ok, _} <- Events.update_topic(topic, %{status: :inactive}) do
      send_resp(conn, :no_content, "")
    end
  end
end
