defmodule FungiTest do
  use ExUnit.Case
  doctest Fungi

  setup_all do

    {:ok, accounts} = Ethereumex.IpcClient.request("personal_listAccounts", [], [])

    if length(accounts) < 2 do
      {:ok, new_account} = Ethereumex.IpcClient.request("personal_newAccount", ["foobar"], [])
      Ethereumex.IpcClient.request("personal_unlockAccount", [new_account, "foobar", nil], [])
    end
    
    Fungi.init_contract

    Fungi.new_point(Enum.at(ExW3.accounts(), 0))
    Fungi.new_point(Enum.at(ExW3.accounts(), 1))
    
    %{
      account0: Enum.at(ExW3.accounts(), 0),
      account1: Enum.at(ExW3.accounts(), 1)
      }
  end

  test "enough accounts", context do
    assert(context[:account0])
    assert(context[:account1])
  end

  test "new point/get point", context do 

    {x, y} = Fungi.get_point(context[:account0])

    assert x |> is_integer
    assert y |> is_integer
  end

  test "link address works both ways", context do
    link = Fungi.to_link_address(context[:account0], context[:account1])
    other_link = Fungi.to_link_address(context[:account1], context[:account0])

    assert link == other_link
  end

  test "new connection", context do
    {:ok, _} = Ethereumex.IpcClient.request("personal_unlockAccount", [Enum.at(ExW3.accounts(), 1), "foobar", nil], [])
    
    {:ok, _} = Fungi.new_connection_request(context[:account0], context[:account1])    

    link = Fungi.to_link_address(context[:account0], context[:account1])

    {:ok, tx_hash} = Fungi.approve_connection_request(link, context[:account1])

    {:ok, {receipt, logs}} = ExW3.Contract.tx_receipt(:Fungi, tx_hash)

    log = Enum.at(logs, 0)

    assert(ExW3.to_address(log["alice"]) == context[:account1])
    assert(ExW3.to_address(log["bob"]) == context[:account0])
							       
    {alice, bob} = Fungi.get_connection(link)

    assert alice == context[:account1]
    assert bob == context[:account0]
  end

  test "account1 requests new connection", context do
    {:ok, _} = Ethereumex.IpcClient.request("personal_unlockAccount", [Enum.at(ExW3.accounts(), 1), "foobar", nil], [])
    
    {:ok, _} = Fungi.new_connection_request(context[:account1], context[:account0])
    link = Fungi.to_link_address(context[:account0], context[:account1])

    Fungi.approve_connection_request(link, context[:account0])

    {alice, bob} = Fungi.get_connection(link)

    assert alice == context[:account0]
    assert bob == context[:account1]
  end

end
