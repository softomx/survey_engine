defmodule SurveyEngine.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.Notifications` context.
  """

  @doc """
  Generate a notification.
  """
  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(%{
        action: "some action",
        content: "some content",
        from: "some from",
        from_name: "some from_name",
        subject: "some subject",
        to: ["option1", "option2"]
      })
      |> SurveyEngine.Notifications.create_notification()

    notification
  end
end
