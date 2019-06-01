defmodule Fowl.LeaguesTest do
  use Fowl.DataCase

  alias Fowl.Leagues

  describe "leagues" do
    alias Fowl.Leagues.League

    @valid_attrs %{draft_time: "2010-04-17T14:00:00Z", name: "some name"}
    @update_attrs %{draft_time: "2011-05-18T15:01:01Z", name: "some updated name"}
    @invalid_attrs %{draft_time: nil, name: nil}

    def league_fixture(attrs \\ %{}) do
      {:ok, league} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leagues.create_league()

      league
    end

    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Leagues.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id" do
      league = league_fixture()
      assert Leagues.get_league!(league.id) == league
    end

    test "create_league/1 with valid data creates a league" do
      assert {:ok, %League{} = league} = Leagues.create_league(@valid_attrs)
      assert league.draft_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert league.name == "some name"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      assert {:ok, %League{} = league} = Leagues.update_league(league, @update_attrs)
      assert league.draft_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert league.name == "some updated name"
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Leagues.update_league(league, @invalid_attrs)
      assert league == Leagues.get_league!(league.id)
    end

    test "delete_league/1 deletes the league" do
      league = league_fixture()
      assert {:ok, %League{}} = Leagues.delete_league(league)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_league!(league.id) end
    end

    test "change_league/1 returns a league changeset" do
      league = league_fixture()
      assert %Ecto.Changeset{} = Leagues.change_league(league)
    end
  end
end
