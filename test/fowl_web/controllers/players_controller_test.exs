defmodule FowlWeb.PlayersControllerTest do
  use FowlWeb.ConnCase

  alias Fowl.OWL
  alias Fowl.OWL.Players

  @create_attrs %{
    blizzard_id: 42
  }
  @update_attrs %{
    blizzard_id: 43
  }
  @invalid_attrs %{blizzard_id: nil}

  def fixture(:players) do
    {:ok, players} = OWL.create_players(@create_attrs)
    players
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all players", %{conn: conn} do
      conn = get(conn, Routes.players_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create players" do
    test "renders players when data is valid", %{conn: conn} do
      conn = post(conn, Routes.players_path(conn, :create), players: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.players_path(conn, :show, id))

      assert %{
               "id" => id,
               "blizzard_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.players_path(conn, :create), players: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update players" do
    setup [:create_players]

    test "renders players when data is valid", %{conn: conn, players: %Players{id: id} = players} do
      conn = put(conn, Routes.players_path(conn, :update, players), players: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.players_path(conn, :show, id))

      assert %{
               "id" => id,
               "blizzard_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, players: players} do
      conn = put(conn, Routes.players_path(conn, :update, players), players: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete players" do
    setup [:create_players]

    test "deletes chosen players", %{conn: conn, players: players} do
      conn = delete(conn, Routes.players_path(conn, :delete, players))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.players_path(conn, :show, players))
      end
    end
  end

  defp create_players(_) do
    players = fixture(:players)
    {:ok, players: players}
  end
end
