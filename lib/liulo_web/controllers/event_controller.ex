defmodule LiuloWeb.EventController do
  use LiuloWeb, :controller

  alias Liulo.Events
  alias Liulo.Events.Event
  alias Liulo.Repo

  action_fallback(LiuloWeb.FallbackController)

  def index(conn, _params) do
    user = Liulo.Guardian.Plug.current_resource(conn)
    event = Events.list_event_by_user(user)
    render(conn, "index.json", event: event)
  end

  def create(conn, %{"event" => event_params}) do
    user = Liulo.Guardian.Plug.current_resource(conn)

    with {:ok, %Event{} = event} <- Events.create_event(user, event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Liulo.Repo.get_by!(Event, code: id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_my_event(conn, %{"event_id" => id}) do
    user = Liulo.Guardian.Plug.current_resource(conn)

    with %Event{} = event <- Repo.get_by(Event, code: id, owner_id: user.id),
         event <- event |> Repo.preload(topics: [:owner, :questions]) do
      render(conn, "show.json", event: event)
    end
  end
end
