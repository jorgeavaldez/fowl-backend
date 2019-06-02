defmodule FowlWeb.UserController do
  use FowlWeb, :controller

  alias Fowl.Accounts
  alias Fowl.Accounts.User

  action_fallback FowlWeb.FallbackController

  def register(conn, params) do
    case Fowl.Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_status(:ok)
        |> put_view(FowlWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user)
        |> put_status(:unauthorized)
        |> put_view(FowlWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Fowl.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_status(:ok)
        |> put_view(FowlWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user)
        |> put_status(:unauthorized)
        |> put_view(FowlWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
