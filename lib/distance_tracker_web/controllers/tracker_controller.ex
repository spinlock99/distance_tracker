defmodule DistanceTrackerWeb.TrackerController do
  use DistanceTrackerWeb, :controller
  use PhoenixSwagger

  alias DistanceTracker.{Repo, Users}
  alias DistanceTracker.Users.Tracker
  alias DistanceTrackerWeb.ErrorView
  alias Plug.Conn

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
    with tracker = %Tracker{} <- Repo.get(Tracker, id) do
      render(conn, "show.json", tracker: tracker)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Users.get_tracker!(id)

    with {:ok, %Tracker{} = tracker} <- Users.update_tracker(tracker, tracker_params) do
      render(conn, "show.json", tracker: tracker)
    end
  end

  def delete(conn, %{"id" => uuid}) do
    with tracker = %Tracker{} <- Repo.get(Tracker, uuid) do
      Repo.delete!(tracker)
      conn
      |> Conn.put_status(204)
      |> Conn.send_resp(:no_content, "")
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
