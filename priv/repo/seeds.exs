# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fowl.Repo.insert!(%Fowl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  @seed_file File.read!("/Users/amandaesposito/projects/fowl/fowl-backend/priv/repo/players.json")

  def get_players_json do
    Jason.decode!(@seed_file)
  end
end

{:ok, last_player} = Seeds.get_players_json()["content"]
|> Enum.reduce(fn player, _ ->
  %{blizzard_id: player["id"]}
  |> Fowl.OWL.create_players
end)

{:ok, user} = Fowl.Accounts.create_user(%{
  email: "test@email.com",
  password: "password"
})

{:ok, league} = Fowl.Leagues.create_league(%{
  draft_time: "2016-09-13T23:30:52.123Z",
  name: "the league"
})

{:ok, team} = Fowl.Leagues.create_team(%{
  "name" => "test team",
  "league" => league.id,
  "user" => user.id,
})

Fowl.Leagues.create_team_player(%{
  "team" => team.id,
  "player" => last_player.id,
})
