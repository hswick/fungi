defmodule Fungi do
  @moduledoc """
  Documentation for Fungi.
  """

  def init_contract do
    ExW3.Contract.start_link

    abi = ExW3.load_abi("/build/Fungi.abi")

    ExW3.Contract.register(:Fungi, abi: abi)

    {:ok, address, _ } =
      ExW3.Contract.deploy(
	:Fungi,
	bin: ExW3.load_bin("/build/Fungi.bin"),
	args: [],
	options: %{
	  gas: 300_000,
	  from: Enum.at(ExW3.accounts, 0)
	}
      )

    ExW3.Contract.at(:Fungi, address)    
  end

  def new_point(account) do
    ExW3.Contract.send(:Fungi, :newPoint, [], %{from: account})
  end

  def get_point(account) do
    {:ok, point} = ExW3.Contract.call(:Fungi, :getPoint, [account])
    point
  end

  def new_connection_request(account0, account1) do
    ExW3.Contract.send(:Fungi, :newConnectionRequest, [account1], %{from: account0})
  end

  def approve_connection_request(account0, account1) do
    ExW3.Contract.send(:Fungi, :approveConnectionRequest, [account1], %{from: account0})
  end

  def link_address(account0, account1) do
    {:ok, address} = ExW3.Contract.call(:Fungi, :linkAddress, [account0, account1])
    address
  end

  def get_connection(link_address) do
    {:ok, connection} = ExW3.Contract.call(:Fungi, :getConnection, [link_address])
    connection
  end

end
