defmodule FungiTest do
  use ExUnit.Case
  doctest Fungi

  setup do
    Fungi.init_contract
    :ok
  end

  test "deploys Fungi" do
    
    assert Fungi.hello == 42       
    
  end

end
