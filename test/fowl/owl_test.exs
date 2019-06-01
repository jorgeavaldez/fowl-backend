defmodule Fowl.OWLTest do
  use Fowl.DataCase

  alias Fowl.OWL

  describe "players" do
    alias Fowl.OWL.Players

    @valid_attrs %{blizzard_id: 42}
    @update_attrs %{blizzard_id: 43}
    @invalid_attrs %{blizzard_id: nil}

    def players_fixture(attrs \\ %{}) do
      {:ok, players} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OWL.create_players()

      players
    end

    test "list_players/0 returns all players" do
      players = players_fixture()
      assert OWL.list_players() == [players]
    end

    test "get_players!/1 returns the players with given id" do
      players = players_fixture()
      assert OWL.get_players!(players.id) == players
    end

    test "create_players/1 with valid data creates a players" do
      assert {:ok, %Players{} = players} = OWL.create_players(@valid_attrs)
      assert players.blizzard_id == 42
    end

    test "create_players/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OWL.create_players(@invalid_attrs)
    end

    test "update_players/2 with valid data updates the players" do
      players = players_fixture()
      assert {:ok, %Players{} = players} = OWL.update_players(players, @update_attrs)
      assert players.blizzard_id == 43
    end

    test "update_players/2 with invalid data returns error changeset" do
      players = players_fixture()
      assert {:error, %Ecto.Changeset{}} = OWL.update_players(players, @invalid_attrs)
      assert players == OWL.get_players!(players.id)
    end

    test "delete_players/1 deletes the players" do
      players = players_fixture()
      assert {:ok, %Players{}} = OWL.delete_players(players)
      assert_raise Ecto.NoResultsError, fn -> OWL.get_players!(players.id) end
    end

    test "change_players/1 returns a players changeset" do
      players = players_fixture()
      assert %Ecto.Changeset{} = OWL.change_players(players)
    end
  end
end
