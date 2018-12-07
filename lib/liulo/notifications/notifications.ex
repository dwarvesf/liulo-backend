defmodule Liulo.Notifications do
  alias LiuloWeb.TopicChannel

  def notify_when_update_topic(topic_id, %{} = payload) do
    send_notification(topic_id, "update_topic", "update topic", payload)
  end

  def notify_when_new_question(topic_id, %{} = payload) do
    send_notification(topic_id, "new_question", "create question", payload)
  end

  def notify_when_upvote_question(topic_id, %{} = payload) do
    send_notification(topic_id, "upvote_question", "upvote question", payload)
  end

  def notify_when_downvote_question(topic_id, %{} = payload) do
    send_notification(topic_id, "downvote_question", "downvote question", payload)
  end

  defp send_notification(topic_id, event, message, %{} = payload) do
    TopicChannel.broadcast_change(topic_id, event, message, payload)
  end
end
