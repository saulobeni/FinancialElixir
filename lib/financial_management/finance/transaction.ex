defmodule FinancialManagement.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias FinancialManagement.Finance.Tag

  schema "transactions" do
    field :type, :string
    field :value, :decimal
    field :date, :naive_datetime
    field :description, :string
    field :user_id, :id

    has_many :transaction_tags, FinancialManagement.Finance.TransactionTag

    many_to_many :tags, FinancialManagement.Finance.Tag,
      join_through: FinancialManagement.Finance.TransactionTag,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:description, :value, :type, :date, :user_id])
    |> validate_required([:description, :value, :type, :date, :user_id])
  end
end
