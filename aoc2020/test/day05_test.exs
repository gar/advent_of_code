defmodule Day05Test do
  use ExUnit.Case

  alias AoC2020.Day05, as: D5

  test "terminate search range" do
    assert D5.search([], 7..7) == 7
  end

  test "search high" do
    assert D5.search([ "R" ], 6..7) == 7
  end

  test "search boarding id seat number" do
    assert D5.seat_id("BFFFBBFRRR") == 567
  end
end
