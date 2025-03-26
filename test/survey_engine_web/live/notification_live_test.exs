defmodule SurveyEngineWeb.NotificationLiveTest do
  use SurveyEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import SurveyEngine.NotificationsFixtures

  @create_attrs %{action: "some action", to: ["option1", "option2"], from: "some from", from_name: "some from_name", subject: "some subject", content: "some content"}
  @update_attrs %{action: "some updated action", to: ["option1"], from: "some updated from", from_name: "some updated from_name", subject: "some updated subject", content: "some updated content"}
  @invalid_attrs %{action: nil, to: [], from: nil, from_name: nil, subject: nil, content: nil}

  defp create_notification(_) do
    notification = notification_fixture()
    %{notification: notification}
  end

  describe "Index" do
    setup [:create_notification]

    test "lists all notifications", %{conn: conn, notification: notification} do
      {:ok, _index_live, html} = live(conn, ~p"/notifications")

      assert html =~ "Listing Notifications"
      assert html =~ notification.action
    end

    test "saves new notification", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live |> element("a", "New Notification") |> render_click() =~
               "New Notification"

      assert_patch(index_live, ~p"/notifications/new")

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications")

      assert html =~ "Notification created successfully"
      assert html =~ "some action"
    end

    test "updates notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live |> element("a[href='/notifications/#{notification.id}/edit']", "Edit") |> render_click() =~
               "Edit Notification"

      assert_patch(index_live, ~p"/notifications/#{notification}/edit")

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications")

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated action"
    end

    test "deletes notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live |> element("a[phx-value-id=#{notification.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{notification.id}]")
    end
  end

  describe "Show" do
    setup [:create_notification]

    test "displays notification", %{conn: conn, notification: notification} do
      {:ok, _show_live, html} = live(conn, ~p"/notifications/#{notification}")

      assert html =~ "Show Notification"
      assert html =~ notification.action
    end

    test "updates notification within modal", %{conn: conn, notification: notification} do
      {:ok, show_live, _html} = live(conn, ~p"/notifications/#{notification}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Notification"

      assert_patch(show_live, ~p"/notifications/#{notification}/show/edit")

      assert show_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications/#{notification}")

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated action"
    end
  end
end
