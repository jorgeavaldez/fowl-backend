defmodule Fowl.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :league_id, references(:leagues, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:teams, [:league_id])
    create index(:teams, [:user_id])
  end
end
