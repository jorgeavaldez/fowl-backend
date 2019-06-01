defmodule FowlWeb.TeamPlayerControllerTest do
  use FowlWeb.ConnCase

  alias Fowl.Leagues
  alias Fowl.Leagues.TeamPlayer

  @create_attrs %{
    dropped: true
  }
  @update_attrs %{
    dropped: false
  }
  @invalid_attrs %{dropped: nil}
  @current_user_attrs %{
    email: "valdez.a.jorge@gmail.com",
    password: "some password"
  }


  def fixture(:team_player) do
    {:ok, team_player} = Leagues.create_team_player(@create_attrs)
    team_player
  end

  def fixture(:current_user) do
    {:ok, curr_user} = Fowl.Accounts.create_user(@current_user_attrs)
    curr_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: curr_user} = setup_current_user(conn)

    {
      :ok,
      conn: put_req_header(conn, "accept", "application/json"),
      current_user: curr_user
    }
  end

  describe "index" do
    test "lists all team_players", %{conn: conn} do
      conn = get(conn, Routes.team_player_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_player" do
    test "renders team_player when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_player_path(conn, :create), team_player: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_player_path(conn, :show, id))

      assert %{
               "id" => id,
               "dropped" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_player_path(conn, :create), team_player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_player" do
    setup [:create_team_player]

    test "renders team_player when data is valid", %{conn: conn, team_player: %TeamPlayer{id: id} = team_player} do
      conn = put(conn, Routes.team_player_path(conn, :update, team_player), team_player: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_player_path(conn, :show, id))

      assert %{
               "id" => id,
               "dropped" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_player: team_player} do
      conn = put(conn, Routes.team_player_path(conn, :update, team_player), team_player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_player" do
    setup [:create_team_player]

    test "deletes chosen team_player", %{conn: conn, team_player: team_player} do
      conn = delete(conn, Routes.team_player_path(conn, :delete, team_player))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_player_path(conn, :show, team_player))
      end
    end
  end

  defp create_team_player(_) do
    team_player = fixture(:team_player)
    {:ok, team_player: team_player}
  end

  defp setup_current_user(conn) do
    curr_user = fixture(:current_user)

    {
      :ok,
      conn: Plug.Test.init_test_session(conn, current_user: curr_user.id),
      current_user: curr_user
    }
  end
end
