defmodule Fowl.OWL.Players do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :blizzard_id, :integer

    timestamps()
  end

  @doc false
  def changeset(players, attrs) do
    players
    |> cast(attrs, [:blizzard_id])
    |> validate_required([:blizzard_id])
  end
end
