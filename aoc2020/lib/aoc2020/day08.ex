defmodule AoC2020.Day08 do

  @input "../../assets/day08_input.txt" |> Path.expand(__DIR__) |> File.read!()
  @test """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """
  @simple """
  nop +0
  acc -1
  """

  def part1 do
    load_instructions()
    |> run()
    |> elem(1)
  end

  def part2 do
    load_instructions()
    |> generate_variants()
    |> Stream.map(&run/1)
    |> Enum.find(fn { result, _ } -> result == :ok end)
  end

  def run(instructions) do
    run(instructions, 0, 0, MapSet.new())
  end

  def run(instructions, ptr, acc, visited) do
    instructions
    |> maybe_handle(ptr, acc, visited, loop?(visited, ptr), halt?(instructions, ptr))
  end

  def maybe_handle(_, _, acc, _, _loop = true, _), do: { :error, acc }
  def maybe_handle(_, _, acc, _, _, _halt = true), do: { :ok, acc }
  def maybe_handle(instructions, ptr, acc, visited, _, _) do
    { new_ptr, new_acc } = handle(Map.get(instructions, ptr), ptr, acc)
    run(instructions, new_ptr, new_acc, MapSet.put(visited, ptr))
  end

  def handle({ "nop", _ }, ptr, acc), do: { ptr + 1, acc }
  def handle({ "acc", n }, ptr, acc), do: { ptr + 1, acc + n }
  def handle({ "jmp", n }, ptr, acc), do: { ptr + n, acc }

  def loop?(visited, ptr), do: MapSet.member?(visited, ptr)

  def halt?(instructions, ptr), do: ptr >= length(Map.keys(instructions))

  def generate_variants(instructions) do
    instructions
    |> Map.to_list()
    |> Enum.filter(fn { _, { inst, _ } } -> Enum.member?([ "jmp", "nop" ], inst) end)
    |> Enum.map(fn { ptr, { inst, n } } -> Map.replace(instructions, ptr, { toggle(inst), n }) end)
  end

  def toggle("jmp"), do: "nop"
  def toggle("nop"), do: "jmp"

  def load_instructions() do
    @input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction_line/1)
    |> Enum.with_index()
    |> Map.new(fn { inst, idx } -> { idx, inst } end)
  end

  def parse_instruction_line(line) do
    [ inst, num_str ] = String.split(line)
    { num, "" } = Integer.parse(num_str)
    { inst, num }
  end

end
