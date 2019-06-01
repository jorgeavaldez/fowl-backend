defmodule FowlWeb.PlayersController do
  use FowlWeb, :controller

  alias Fowl.OWL
  alias Fowl.OWL.Players

  action_fallback FowlWeb.FallbackController

  def index(conn, _params) do
    players = OWL.list_players()
    render(conn, "index.json", players: players)
  end

  def create(conn, %{"players" => players_params}) do
    with {:ok, %Players{} = players} <- OWL.create_players(players_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.players_path(conn, :show, players))
      |> render("show.json", players: players)
    end
  end

  def show(conn, %{"id" => id}) do
    players = OWL.get_players!(id)
    render(conn, "show.json", players: players)
  end

  def update(conn, %{"id" => id, "players" => players_params}) do
    players = OWL.get_players!(id)

    with {:ok, %Players{} = players} <- OWL.update_players(players, players_params) do
      render(conn, "show.json", players: players)
    end
  end

  def delete(conn, %{"id" => id}) do
    players = OWL.get_players!(id)

    with {:ok, %Players{}} <- OWL.delete_players(players) do
      send_resp(conn, :no_content, "")
    end
  end
end
