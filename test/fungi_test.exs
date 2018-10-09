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

  test "link address works both ways", context do
    link = Fungi.to_link_address(context[:account0], context[:account1])
    other_link = Fungi.to_link_address(context[:account1], context[:account0])

    assert link == other_link
  end

  test "new connection", context do
    Fungi.new_connection_request(context[:account0], context[:account1])    

    link = Fungi.to_link_address(context[:account0], context[:account1])

    Fungi.approve_connection_request(link, context[:account1])    

    {alice, bob} = Fungi.get_connection(link)

    assert alice == context[:account1]
    assert bob == context[:account0]
  end

end
