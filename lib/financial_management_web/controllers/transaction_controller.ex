defmodule FinancialManagementWeb.TransactionController do
  use FinancialManagementWeb, :controller

  alias FinancialManagement.Finance
  alias FinancialManagement.Finance.Transaction

  action_fallback FinancialManagementWeb.FallbackController

  def index(conn, _params) do
    transactions = Finance.list_transactions()
    conn
    |> put_status(:ok)
    |> render(:index, transactions: transactions)
  end

  def show(conn, %{"id" => id}) do
    transaction = Finance.get_transaction!(id)

    conn
    |> put_status(:ok)
    |> render(:show, transaction: transaction)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    transaction_params =
      transaction_params
      |> Map.put("user_id", current_user.id)

    case Finance.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> render(:show, transaction: transaction)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Finance.get_transaction!(id)

    case Finance.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_status(:ok)
        |> render(:show, transaction: transaction)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Finance.get_transaction!(id)

    case Finance.delete_transaction(transaction) do
      {:ok, _transaction} ->
        send_resp(conn, :no_content, "")

      {:error, _reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Erro ao excluir a transação"})
    end
  end
end
