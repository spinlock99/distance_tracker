defmodule DistanceTrackerWeb.TrackerController do
  use DistanceTrackerWeb, :controller

  alias DistanceTracker.Users
  alias DistanceTracker.Users.Tracker

  action_fallback DistanceTrackerWeb.FallbackController

  def index(conn, _params) do
    trackers = Users.list_trackers()
    render(conn, "index.json", trackers: trackers)
  end

  def create(conn, %{"tracker" => tracker_params}) do
    with {:ok, %Tracker{} = tracker} <- Users.create_tracker(tracker_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", tracker_path(conn, :show, tracker))
      |> render("show.json", tracker: tracker)
    end
  end

  def show(conn, %{"id" => id}) do
    tracker = Users.get_tracker!(id)
    render(conn, "show.json", tracker: tracker)
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Users.get_tracker!(id)

    with {:ok, %Tracker{} = tracker} <- Users.update_tracker(tracker, tracker_params) do
      render(conn, "show.json", tracker: tracker)
    end
  end

  def delete(conn, %{"id" => id}) do
    tracker = Users.get_tracker!(id)
    with {:ok, %Tracker{}} <- Users.delete_tracker(tracker) do
      send_resp(conn, :no_content, "")
    end
  end
end
