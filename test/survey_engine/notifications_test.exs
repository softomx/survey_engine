defmodule SurveyEngine.NotificationsTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.Notifications

  describe "notifications" do
    alias SurveyEngine.Notifications.Notification

    import SurveyEngine.NotificationsFixtures

    @invalid_attrs %{action: nil, to: nil, from: nil, from_name: nil, subject: nil, content: nil}

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Notifications.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notifications.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      valid_attrs = %{action: "some action", to: ["option1", "option2"], from: "some from", from_name: "some from_name", subject: "some subject", content: "some content"}

      assert {:ok, %Notification{} = notification} = Notifications.create_notification(valid_attrs)
      assert notification.action == "some action"
      assert notification.to == ["option1", "option2"]
      assert notification.from == "some from"
      assert notification.from_name == "some from_name"
      assert notification.subject == "some subject"
      assert notification.content == "some content"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      update_attrs = %{action: "some updated action", to: ["option1"], from: "some updated from", from_name: "some updated from_name", subject: "some updated subject", content: "some updated content"}

      assert {:ok, %Notification{} = notification} = Notifications.update_notification(notification, update_attrs)
      assert notification.action == "some updated action"
      assert notification.to == ["option1"]
      assert notification.from == "some updated from"
      assert notification.from_name == "some updated from_name"
      assert notification.subject == "some updated subject"
      assert notification.content == "some updated content"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_notification(notification, @invalid_attrs)
      assert notification == Notifications.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notifications.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notifications.change_notification(notification)
    end
  end
end
