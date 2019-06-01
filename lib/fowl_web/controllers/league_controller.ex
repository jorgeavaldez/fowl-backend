defmodule FowlWeb.LeagueController do
  use FowlWeb, :controller

  alias Fowl.Leagues
  alias Fowl.Leagues.League

  action_fallback FowlWeb.FallbackController

  def index(conn, _params) do
    leagues = Leagues.list_leagues()
    render(conn, "index.json", leagues: leagues)
  end

  def create(conn, %{"league" => league_params}) do
    with {:ok, %League{} = league} <- Leagues.create_league(league_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.league_path(conn, :show, league))
      |> render("show.json", league: league)
    end
  end

  def show(conn, %{"id" => id}) do
    league = Leagues.get_league!(id)
    render(conn, "show.json", league: league)
  end

  def update(conn, %{"id" => id, "league" => league_params}) do
    league = Leagues.get_league!(id)

    with {:ok, %League{} = league} <- Leagues.update_league(league, league_params) do
      render(conn, "show.json", league: league)
    end
  end

  def delete(conn, %{"id" => id}) do
    league = Leagues.get_league!(id)

    with {:ok, %League{}} <- Leagues.delete_league(league) do
      send_resp(conn, :no_content, "")
    end
  end
end
