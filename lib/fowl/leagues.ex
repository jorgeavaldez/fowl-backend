defmodule Fowl.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias Fowl.Repo

  alias Fowl.Leagues.League

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    Repo.all(League)
  end

  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples

      iex> get_league!(123)
      %League{}

      iex> get_league!(456)
      ** (Ecto.NoResultsError)

  """
  def get_league!(id), do: Repo.get!(League, id)

  @doc """
  Creates a league.

  ## Examples

      iex> create_league(%{field: value})
      {:ok, %League{}}

      iex> create_league(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_league(attrs \\ %{}) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %League{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a League.

  ## Examples

      iex> delete_league(league)
      {:ok, %League{}}

      iex> delete_league(league)
      {:error, %Ecto.Changeset{}}

  """
  def delete_league(%League{} = league) do
    Repo.delete(league)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking league changes.

  ## Examples

      iex> change_league(league)
      %Ecto.Changeset{source: %League{}}

  """
  def change_league(%League{} = league) do
    League.changeset(league, %{})
  end

  alias Fowl.Leagues.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
    |> Repo.preload(:league)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Repo.get!(Team, id)
    |> Repo.preload(:league)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    league = Repo.get(Fowl.Leagues.League, attrs["league"])
    user = Repo.get(Fowl.Accounts.User, attrs["user"])

    %Team{
      league_id: league.id,
      user_id: user.id,
    }
    |> Team.changeset(%{ name: attrs["name"] })
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %Team{}}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  alias Fowl.Leagues.TeamPlayer

  @doc """
  Returns the list of team_players.

  ## Examples

      iex> list_team_players()
      [%TeamPlayer{}, ...]

  """
  def list_team_players do
    Repo.all(TeamPlayer)
  end

  @doc """
  Gets a single team_player.

  Raises `Ecto.NoResultsError` if the Team player does not exist.

  ## Examples

      iex> get_team_player!(123)
      %TeamPlayer{}

      iex> get_team_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_player!(id), do: Repo.get!(TeamPlayer, id)

  @doc """
  Creates a team_player.

  ## Examples

      iex> create_team_player(%{field: value})
      {:ok, %TeamPlayer{}}

      iex> create_team_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_player(attrs \\ %{}) do
    %TeamPlayer{}
    |> TeamPlayer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_player.

  ## Examples

      iex> update_team_player(team_player, %{field: new_value})
      {:ok, %TeamPlayer{}}

      iex> update_team_player(team_player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_player(%TeamPlayer{} = team_player, attrs) do
    team_player
    |> TeamPlayer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TeamPlayer.

  ## Examples

      iex> delete_team_player(team_player)
      {:ok, %TeamPlayer{}}

      iex> delete_team_player(team_player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_player(%TeamPlayer{} = team_player) do
    Repo.delete(team_player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_player changes.

  ## Examples

      iex> change_team_player(team_player)
      %Ecto.Changeset{source: %TeamPlayer{}}

  """
  def change_team_player(%TeamPlayer{} = team_player) do
    TeamPlayer.changeset(team_player, %{})
  end
end
