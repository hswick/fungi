defmodule FungiTest do
  use ExUnit.Case
  doctest Fungi

  setup_all do
    Fungi.init_contract

    Fungi.new_point(Enum.at(ExW3.accounts(), 0))
    Fungi.new_point(Enum.at(ExW3.accounts(), 1))
    
    %{
      account0: Enum.at(ExW3.accounts(), 0),
      account1: Enum.at(ExW3.accounts(), 1)
      }
  end

  test "new point/get point", context do   

    {x, y} = Fungi.get_point(context[:account0])

    assert x |> is_integer
    assert y |> is_integer
  end

  test "new connection", context do
    Fungi.new_connection_request(context[:account0], context[:account1])

    Fungi.approve_connection_request(context[:account1], context[:account0])

    link = Fungi.link_address(context[:account0], context[:account1])
    other_link = Fungi.link_address(context[:account1], context[:account0])

    assert link == other_link

    {alice, bob} = Fungi.get_connection(link)

    assert alice == context[:account0]
    assert bob == context[:account1]
  end

end
