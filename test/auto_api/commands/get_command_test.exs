defmodule AutoApi.GetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApi.PropCheckFixtures

  doctest AutoApi.GetCommand

  alias AutoApi.GetCommand, as: SUT

  property "new/2 works" do
    forall {capability, properties} <- capability_with_properties() do
      command = SUT.new(capability, properties)

      assert %SUT{capability: capability, properties: properties} == command
    end
  end

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, properties} <- capability_with_properties() do
      command = SUT.new(capability, properties)

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end
end
