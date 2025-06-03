defmodule FinancialManagement.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> maybe_validate_password()
    |> put_hashed_password()
  end

  defp maybe_validate_password(changeset) do
    if get_field(changeset, :password) do
      changeset
      |> validate_length(:password, min: 6)
    else
      changeset
    end
  end

  defp put_hashed_password(changeset) do
    if password = get_change(changeset, :password) do
      change(changeset, hashed_password: Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end
end
