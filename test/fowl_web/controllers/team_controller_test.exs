defmodule FowlWeb.TeamControllerTest do
  use FowlWeb.ConnCase

  alias Fowl.Leagues
  alias Fowl.Leagues.Team

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}
  @current_user_attrs %{
    email: "valdez.a.jorge@gmail.com",
    password: "some password"
  }

  def fixture(:team) do
    {:ok, team} = Leagues.create_team(@create_attrs)
    team
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
    test "lists all teams", %{conn: conn} do
      conn = get(conn, Routes.team_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_path(conn, :create), team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_path(conn, :create), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, Routes.team_path(conn, :update, team), team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, Routes.team_path(conn, :update, team), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, Routes.team_path(conn, :delete, team))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_path(conn, :show, team))
      end
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
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
