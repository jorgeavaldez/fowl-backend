defmodule Fowl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    has_many :teams, Fowl.Leagues.Team

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> hash_password_for
  end

  defp hash_password_for(
    %Changeset{
      valid?: true,
      changes: %{password: password}
    } = changeset
  ) do
    change(changeset, encrypted_password: Argon2.hash_pwd_salt(password))
  end

  defp hash_password_for(changeset), do: changeset
end
