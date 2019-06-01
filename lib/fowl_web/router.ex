defmodule FowlWeb.Router do
  use FowlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_authenticated do
    plug :ensure_authenticated
  end

  scope "/api", FowlWeb do
    pipe_through :api
    post "/users/login", UserController, :login
  end

  scope "/api", FowlWeb do
    pipe_through [:api, :api_authenticated]
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api/league", FowlWeb do
    pipe_through [:api]
    resources "/players", PlayersController, except: [:new, :edit]
  end

  scope "/api/league", FowlWeb do
    pipe_through [:api, :api_authenticated]
    resources "/leagues", LeagueController, except: [:new, :edit]
    resources "/teams", TeamController, except: [:new, :edit]
  end

  defp ensure_authenticated(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(FowlWeb.ErrorView)
        |> render("401.json", message: "Unauthenticated User")
        |> halt()
      _ ->
        conn
    end
  end
end
