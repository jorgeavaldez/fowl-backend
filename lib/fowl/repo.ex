defmodule Fowl.Repo do
  use Ecto.Repo,
    otp_app: :fowl,
    adapter: Ecto.Adapters.Postgres
end
