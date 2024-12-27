defmodule GiocciExampleTest do
  use ExUnit.Case
  doctest GiocciExample

  test "greets the world" do
    assert GiocciExample.hello() == :world
  end
end
