defmodule Fowl.Repo.Migrations.CreateTeamPlayers do
  use Ecto.Migration

  def change do
    create table(:team_players) do
      add :dropped, :boolean, default: false, null: false
      add :team_id, references(:teams, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:team_players, [:team_id])
    create index(:team_players, [:player_id])
  end
end
