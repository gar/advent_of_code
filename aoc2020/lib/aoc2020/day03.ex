defmodule AoC2020.Day03 do
  @tree_character "#"
  @input "../../assets/day03_input.txt" |> Path.expand(__DIR__)

  def part1 do
    @input
    |> File.read!()
    |> tree_collisions(3, 1)
    |> IO.inspect()
  end

  def part2 do
    map = File.read!(@input)
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn { right, down } -> tree_collisions(map, right, down) end)
    |> Enum.reduce(&*/2)
    |> IO.inspect
  end

  def tree_collisions(map, right, down) do
    trees = tree_coords(map)
    path = slope_coords(map_height(map), map_width(map), right, down)
    MapSet.intersection(trees, path)
    |> MapSet.size()
  end

  def map_dimensions(map) do
    { map_height(map), map_width(map) }
  end

  defp map_height(map) do
    map
    |> String.split("\n", trim: true)
    |> length()
  end

  defp map_width(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> String.length()
  end

  def tree_coords(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.filter(fn { c, _ } -> c == @tree_character end)
    |> Enum.map(fn { _, coords } -> coords end)
    |> MapSet.new()
  end

  defp parse_row({ row, x }) do
    row
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.map(fn { c, y } -> { c, { x, y } } end)
  end

  def slope_coords(height, width, right, down) do
    xs = xs(height, down)
    ys = ys(width, right, length(xs))
    Enum.zip(xs, ys)
    |> MapSet.new()
  end

  def xs(height, step_size) do
    0..(height-1)
    |> Enum.take_every(step_size)
    |> Enum.drop(1)
  end

  def ys(width, step_size, num) do
    0..(width-1)
    |> Stream.cycle()
    |> Stream.take_every(step_size)
    |> Stream.drop(1)
    |> Enum.take(num)
  end
end
