defmodule LiuloWeb.TopicView do
  use LiuloWeb, :view
  alias LiuloWeb.TopicView

  def render("index.json", %{topic: topic}) do
    %{data: render_many(topic, TopicView, "simple_topic.json")}
  end

  def render("show.json", %{topic: topic}) do
    %{data: render_one(topic, TopicView, "topic.json")}
  end

  def render("simple_topic.json", %{topic: topic}) do
    %{
      id: topic.id,
      name: topic.name,
      description: topic.description,
      started_at: topic.started_at,
      ended_at: topic.ended_at,
      speaker_names: topic.speaker_names,
      status: topic.status,
      code: topic.code
    }
  end

  def render("topic.json", %{topic: topic}) do
    %{
      id: topic.id,
      name: topic.name,
      description: topic.description,
      started_at: topic.started_at,
      ended_at: topic.ended_at,
      speaker_names: topic.speaker_names,
      status: topic.status,
      code: topic.code,
      questions: render_many(topic.questions, LiuloWeb.QuestionView, "question.json")
    }
  end
end
