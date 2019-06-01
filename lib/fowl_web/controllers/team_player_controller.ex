defmodule FowlWeb.TeamPlayerController do
  use FowlWeb, :controller

  alias Fowl.Leagues
  alias Fowl.Leagues.TeamPlayer

  action_fallback FowlWeb.FallbackController

  def index(conn, _params) do
    team_players = Leagues.list_team_players()
    render(conn, "index.json", team_players: team_players)
  end

  def create(conn, %{"team_player" => team_player_params}) do
    with {:ok, %TeamPlayer{} = team_player} <- Leagues.create_team_player(team_player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_player_path(conn, :show, team_player))
      |> render("show.json", team_player: team_player)
    end
  end

  def show(conn, %{"id" => id}) do
    team_player = Leagues.get_team_player!(id)
    render(conn, "show.json", team_player: team_player)
  end

  def update(conn, %{"id" => id, "team_player" => team_player_params}) do
    team_player = Leagues.get_team_player!(id)

    with {:ok, %TeamPlayer{} = team_player} <- Leagues.update_team_player(team_player, team_player_params) do
      render(conn, "show.json", team_player: team_player)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_player = Leagues.get_team_player!(id)

    with {:ok, %TeamPlayer{}} <- Leagues.delete_team_player(team_player) do
      send_resp(conn, :no_content, "")
    end
  end
end
