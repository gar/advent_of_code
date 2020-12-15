defmodule AoC2020.Day10 do

  @input "../../assets/day10_input.txt" |> Path.expand(__DIR__) |> File.read!()
  @test_small """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """
  @test_large """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
  """

  def part1 do
    diffs = ratings() |> differences()

    ones = Enum.count(diffs, fn d -> d == 1 end)
    threes = Enum.count(diffs, fn d -> d == 3 end)

    ones * threes
  end

  def part2 do
    { :ok, pid } = Agent.start_link(fn -> %{} end)

    ratings()
    |> progressions(pid)
  end

  def progressions([_], _pid), do: 1
  def progressions(rs = [ h | t ], pid) do
    t
    |> Enum.split(3)
    |> elem(0)
    |> Enum.count(fn x -> x - h <= 3 end)
    |> (fn choices -> Range.new(1, choices) end).()
    |> Enum.map(fn n -> Enum.drop(rs, n) end)
    |> Enum.reduce(0,
      fn next = [ f | _ ], acc ->
        n = Agent.get(pid, fn memo -> Map.get(memo, f) end)
        cond do
          n == nil ->
            acc + progressions(next, pid)
          true ->
            acc + n
        end
      end)
    |> (fn result -> Agent.get_and_update(pid, &({ result, Map.put(&1, h, result)})) end).()
  end

  def differences(nums) do
    nums
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [ a, b ] -> b - a end)
  end

  def ratings() do
    ratings = load_input()
    device_rating = Enum.max(ratings) + 3

    [ 0, device_rating | ratings ]
    |> Enum.sort()
  end

  def load_input() do
    @input
    |> String.split("\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
  end
end
