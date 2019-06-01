defmodule Fowl.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :blizzard_id, :integer

      timestamps()
    end

  end
end
