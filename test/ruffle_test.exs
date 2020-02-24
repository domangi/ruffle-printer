defmodule RuffleTest do
  use ExUnit.Case
  doctest Ruffle

  test "greets the world" do
    assert Ruffle.hello() == :world
  end
end
