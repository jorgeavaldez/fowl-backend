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
  @seed_file File.read!("/Users/jorge/projects/fowl/priv/repo/players.json")

  def get_players_json do
    Jason.decode!(@seed_file)
  end
end

Seeds.get_players_json()["content"]
|> Enum.each(fn player ->
  %{blizzard_id: player["id"]}
  |> Fowl.OWL.create_players
end)
