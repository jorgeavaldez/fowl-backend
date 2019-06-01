defmodule Fowl.Leagues.TeamPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_players" do
    field :dropped, :boolean, default: false
    belongs_to :team, Fowl.Leagues.Team
    belongs_to :player, Fowl.OWL.Players

    timestamps()
  end

  @doc false
  def changeset(team_player, attrs) do
    team_player
    |> cast(attrs, [:dropped])
    |> validate_required([:dropped])
  end
end
