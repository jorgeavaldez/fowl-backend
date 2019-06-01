defmodule FowlWeb.UserControllerTest do
  use FowlWeb.ConnCase

  alias Fowl.Accounts
  alias Fowl.Accounts.User

  @create_attrs %{
    email: "some email",
    password: "some encrypted_password"
  }
  @update_attrs %{
    email: "some updated email",
    password: "some updated encrypted_password"
  }
  @invalid_attrs %{email: nil, password: nil}
  @current_user_attrs %{
    email: "some current user email",
    password: "some current user encrypted_password"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def fixture(:current_user) do
    {:ok, curr_user} = Accounts.create_user(@current_user_attrs)
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
    test "lists all users", %{conn: conn, current_user: curr_user} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == [
        %{
          "id" => curr_user.id,
          "email" => curr_user.email,
        }
      ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
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
