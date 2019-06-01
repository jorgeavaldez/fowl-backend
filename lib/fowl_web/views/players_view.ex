defmodule FowlWeb.PlayersView do
  use FowlWeb, :view
  alias FowlWeb.PlayersView

  def render("index.json", %{players: players}) do
    %{data: render_many(players, PlayersView, "players.json")}
  end

  def render("show.json", %{players: players}) do
    %{data: render_one(players, PlayersView, "players.json")}
  end

  def render("players.json", %{players: players}) do
    %{id: players.id,
      blizzard_id: players.blizzard_id}
  end
end
