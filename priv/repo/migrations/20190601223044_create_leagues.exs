defmodule Fowl.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :draft_time, :utc_datetime

      timestamps()
    end

  end
end
