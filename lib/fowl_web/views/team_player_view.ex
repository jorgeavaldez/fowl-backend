defmodule FowlWeb.TeamPlayerView do
  use FowlWeb, :view
  alias FowlWeb.TeamPlayerView

  def render("index.json", %{team_players: team_players}) do
    %{data: render_many(team_players, TeamPlayerView, "team_player.json")}
  end

  def render("show.json", %{team_player: team_player}) do
    %{data: render_one(team_player, TeamPlayerView, "team_player.json")}
  end

  def render("team_player.json", %{team_player: team_player}) do
    %{
      id: team_player.id,
      dropped: team_player.dropped,
      team: render_one(team_player.team, FowlWeb.TeamView, "team.json"),
      player: render_one(team_player.player, FowlWeb.PlayersView, "players.json"),
    }
  end
end
