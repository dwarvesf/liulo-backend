defmodule LiuloWeb.TopicView do
  use LiuloWeb, :view
  alias LiuloWeb.TopicView

  def render("index.json", %{topic: topic}) do
    %{data: render_many(topic, TopicView, "topic.json")}
  end

  def render("show.json", %{topic: topic}) do
    %{data: render_one(topic, TopicView, "topic.json")}
  end

  def render("topic.json", %{topic: topic}) do
    %{id: topic.id,
      name: topic.name,
      description: topic.description,
      started_at: topic.started_at,
      ended_at: topic.ended_at,
      speaker_names: topic.speaker_names,
      status: topic.status}
  end
end
