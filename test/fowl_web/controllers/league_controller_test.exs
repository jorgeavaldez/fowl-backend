defmodule FowlWeb.LeagueControllerTest do
  use FowlWeb.ConnCase

  alias Fowl.Leagues
  alias Fowl.Leagues.League

  @create_attrs %{
    draft_time: "2010-04-17T14:00:00Z",
    name: "some name"
  }
  @update_attrs %{
    draft_time: "2011-05-18T15:01:01Z",
    name: "some updated name"
  }
  @invalid_attrs %{draft_time: nil, name: nil}
  @current_user_attrs %{
    email: "valdez.a.jorge@gmail.com",
    password: "some password"
  }

  def fixture(:league) do
    {:ok, league} = Leagues.create_league(@create_attrs)
    league
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
    test "lists all leagues", %{conn: conn} do
      conn = get(conn, Routes.league_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create league" do
    test "renders league when data is valid", %{conn: conn} do
      conn = post(conn, Routes.league_path(conn, :create), league: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.league_path(conn, :show, id))

      assert %{
               "id" => id,
               "draft_time" => "2010-04-17T14:00:00Z",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.league_path(conn, :create), league: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update league" do
    setup [:create_league]

    test "renders league when data is valid", %{conn: conn, league: %League{id: id} = league} do
      conn = put(conn, Routes.league_path(conn, :update, league), league: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.league_path(conn, :show, id))

      assert %{
               "id" => id,
               "draft_time" => "2011-05-18T15:01:01Z",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, league: league} do
      conn = put(conn, Routes.league_path(conn, :update, league), league: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete league" do
    setup [:create_league]

    test "deletes chosen league", %{conn: conn, league: league} do
      conn = delete(conn, Routes.league_path(conn, :delete, league))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.league_path(conn, :show, league))
      end
    end
  end

  defp create_league(_) do
    league = fixture(:league)
    {:ok, league: league}
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
