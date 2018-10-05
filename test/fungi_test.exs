defmodule FungiTest do
  use ExUnit.Case
  doctest Fungi

  setup do
    Fungi.init_contract
    :ok
  end

  test "calls hello" do    
    assert Fungi.hello == 42    
  end

end
