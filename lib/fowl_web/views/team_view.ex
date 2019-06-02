defmodule FowlWeb.TeamView do
  use FowlWeb, :view
  alias FowlWeb.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      league: render_one(team.league, FowlWeb.LeagueView, "league.json"),
      user: render_one(team.user, FowlWeb.UserView, "user.json"),
    }
  end
end
