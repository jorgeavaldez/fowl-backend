defmodule Fowl.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :draft_time, :utc_datetime
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :draft_time])
    |> validate_required([:name, :draft_time])
  end
end
