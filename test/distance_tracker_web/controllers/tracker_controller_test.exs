defmodule DistanceTrackerWeb.TrackerControllerTest do
  use DistanceTrackerWeb.ConnCase

  alias DistanceTracker.Users
  alias DistanceTracker.Users.Tracker

  @create_attrs %{
    activity: "swimming",
    completed_at: DateTime.utc_now(),
    distance: 1500,
    uuid: UUID.uuid4(),
  }
  @update_attrs %{
    activity: "running",
    distance: 3200,
  }
  @invalid_attrs %{activity: nil}


  def fixture(:tracker) do
    {:ok, tracker} = Users.create_tracker(@create_attrs)
    tracker
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all trackers", %{conn: conn} do
      conn = get conn, tracker_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tracker" do
    test "renders tracker when data is valid", %{conn: conn} do
      conn = post conn, tracker_path(conn, :create), tracker: @create_attrs
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get conn, tracker_path(conn, :show, uuid)
      %{
        "activity" => activity,
        "distance" => distance,
      } = json_response(conn, 200)["data"]
      assert activity == @create_attrs[:activity]
      assert distance == @create_attrs[:distance]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tracker_path(conn, :create), tracker: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tracker" do
    setup [:create_tracker]

    test "renders tracker when data is valid", %{conn: conn, tracker: %Tracker{uuid: uuid} = tracker} do
      conn = put conn, tracker_path(conn, :update, tracker), tracker: @update_attrs
      assert %{"uuid" => ^uuid} = json_response(conn, 200)["data"]

      conn = get conn, tracker_path(conn, :show, uuid)
      %{
        "activity" => activity,
        "distance" => distance,
      } = json_response(conn, 200)["data"]
      assert activity == @update_attrs[:activity]
      assert distance == @update_attrs[:distance]
    end

    test "renders errors when data is invalid", %{conn: conn, tracker: tracker} do
      conn = put conn, tracker_path(conn, :update, tracker), tracker: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tracker" do
    setup [:create_tracker]

    test "deletes chosen tracker", %{conn: conn, tracker: tracker} do
      conn = delete conn, tracker_path(conn, :delete, tracker)
      assert response(conn, 204)

      conn = get conn, tracker_path(conn, :show, tracker)
      assert json_response(conn, 404) != %{}
    end
  end

  defp create_tracker(_) do
    tracker = fixture(:tracker)
    {:ok, tracker: tracker}
  end
end
