defmodule LiuloWeb.EventView do
  use LiuloWeb, :view
  alias LiuloWeb.EventView

  def render("index.json", %{event: event}) do
    %{data: render_many(event, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      code: event.code,
      name: event.name,
      description: event.description,
      started_at: event.started_at,
      ended_at: event.ended_at,
      status: event.status,
      topics: render_topics(event.topics)
    }
  end

  def render_topics(topics) do
    if Ecto.assoc_loaded?(topics) do
      render_many(topics, LiuloWeb.TopicView, "topic.json")
    else
      []
    end
  end
end
