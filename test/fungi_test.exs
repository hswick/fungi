defmodule FungiTest do
  use ExUnit.Case
  doctest Fungi

  setup do

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
    
    :ok
  end

  test "deploys Fungi" do

      {:ok, num} = ExW3.Contract.call(:Fungi, :hello) 
      
      assert num == 42       
    
  end

end
