defmodule GameTest do
  use ExUnit.Case

  test "test finding trees" do
    small_map = """
    ..
    #.
    """

    coords = AoC2020.Day03.tree_coords(small_map)

    assert not MapSet.member?(coords, {0, 0})
    assert not MapSet.member?(coords, {0, 1})
    assert MapSet.member?(coords, {1, 0})
    assert not MapSet.member?(coords, {1, 1})
  end

  test "generating slope coords" do
    coords = AoC2020.Day03.slope_coords(5, 5, 1, 2)

    assert MapSet.size(coords) == 2
    assert MapSet.member?(coords, {2, 1})
    assert MapSet.member?(coords, {4, 2})
  end

  test "generating slope coords with wrapping" do
    coords = AoC2020.Day03.slope_coords(5, 5, 2, 1)

    assert MapSet.size(coords) == 4
    assert MapSet.member?(coords, {1, 2})
    assert MapSet.member?(coords, {2, 4})
    assert MapSet.member?(coords, {3, 1})
    assert MapSet.member?(coords, {4, 3})
  end

  test "map dimensions" do
    four_by_three = """
    ...
    ...
    ...
    ...
    """

    { height, width } = AoC2020.Day03.map_dimensions(four_by_three)

    assert height == 4
    assert width == 3
  end

  test "test tree collisions" do
    map = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    assert AoC2020.Day03.tree_collisions(map, 3, 1) == 7
  end

end
