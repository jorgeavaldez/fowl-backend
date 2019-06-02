defmodule Fowl.Leagues.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :league, Fowl.Leagues.League
    belongs_to :user, Fowl.Accounts.User
    has_many :team_players, Fowl.Leagues.TeamPlayer

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> cast_assoc(:league, required: false)
    |> cast_assoc(:user, required: false)
    |> validate_required([:name])
    |> validate_length(:team_players, max: 6)
  end
end
