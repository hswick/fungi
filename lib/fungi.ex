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
	  gas: 1_000_000,
	  from: Enum.at(ExW3.accounts, 0)
	}
      )

    ExW3.Contract.at(:Fungi, address)    
  end

  def new_point(account) do
    ExW3.Contract.send(:Fungi, :newPoint, [], %{from: account})
  end

  def get_point(account) do
    {:ok, x, y} = ExW3.Contract.call(:Fungi, :getPoint, [ExW3.to_decimal(account)])
     {x, y}
  end

  def new_connection_request(account0, account1) do
    ExW3.Contract.send(:Fungi, :newConnectionRequest, [ExW3.to_decimal(account1)], %{from: account0, gas: 500_000})
  end

  def approve_connection_request(linkAddress, account) do
    ExW3.Contract.send(:Fungi, :approveConnectionRequest, [linkAddress], %{from: account, gas: 500_000})
  end

  def to_link_address(account0, account1) do
    {:ok, link_address} = ExW3.Contract.call(:Fungi, :toLinkAddress, [ExW3.to_decimal(account0), ExW3.to_decimal(account1)])
    link_address
  end

  def get_connection(link_address) do
    {:ok, alice, bob} = ExW3.Contract.call(:Fungi, :getConnection, [link_address])
    {ExW3.to_address(alice), ExW3.to_address(bob)}
  end

end
