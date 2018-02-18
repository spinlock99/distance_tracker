defmodule DistanceTracker.UsersTest do
  use DistanceTracker.DataCase

  alias DistanceTracker.Users

  describe "trackers" do
    alias DistanceTracker.Users.Tracker

    @valid_attrs %{
      activity: "swimming",
      uuid: UUID.uuid4(),
      completed_at: DateTime.utc_now()
    }
    @update_attrs %{}
    @invalid_attrs %{uuid: 7}

    def tracker_fixture(attrs \\ %{}) do
      {:ok, tracker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_tracker()

      tracker
    end

    test "list_trackers/0 returns all trackers" do
      tracker = tracker_fixture()
      assert Users.list_trackers() == [tracker]
    end

    test "get_tracker!/1 returns the tracker with given id" do
      tracker = tracker_fixture()
      assert Users.get_tracker!(tracker.uuid) == tracker
    end

    test "create_tracker/1 with valid data creates a tracker" do
      assert {:ok, %Tracker{}} = Users.create_tracker(@valid_attrs)
    end

    test "create_tracker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_tracker(@invalid_attrs)
    end

    test "update_tracker/2 with valid data updates the tracker" do
      tracker = tracker_fixture()
      assert {:ok, tracker} = Users.update_tracker(tracker, @update_attrs)
      assert %Tracker{} = tracker
    end

    test "update_tracker/2 with invalid data returns error changeset" do
      tracker = tracker_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_tracker(tracker, @invalid_attrs)
      assert tracker == Users.get_tracker!(tracker.uuid)
    end

    test "delete_tracker/1 deletes the tracker" do
      tracker = tracker_fixture()
      assert {:ok, %Tracker{}} = Users.delete_tracker(tracker)
      assert_raise Ecto.NoResultsError, fn -> Users.get_tracker!(tracker.uuid) end
    end

    test "change_tracker/1 returns a tracker changeset" do
      tracker = tracker_fixture()
      assert %Ecto.Changeset{} = Users.change_tracker(tracker)
    end
  end
end
