defmodule AoC2020.Passport do
  @fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]
  @valid_ecls ~w(amb blu brn gry grn hzl oth)

  defstruct @fields

  def present?(passport = %AoC2020.Passport{}) do
    @fields -- [:cid]
    |> Enum.all?(fn f -> Map.get(passport, f) != nil end)
  end

  def valid?(passport = %AoC2020.Passport{}) do
    @fields
    |> Enum.all?(fn f -> valid?(passport, f) end)
  end
  def valid?(%{ byr: nil }, :byr), do: false
  def valid?(%{ iyr: nil }, :iyr), do: false
  def valid?(%{ eyr: nil }, :eyr), do: false
  def valid?(%{ hgt: nil }, :hgt), do: false
  def valid?(%{ hcl: nil }, :hcl), do: false
  def valid?(%{ ecl: nil }, :ecl), do: false
  def valid?(%{ pid: nil }, :pid), do: false

  def valid?(%{ byr: byr }, :byr), do: string_num_between?(byr, 1920, 2002)
  def valid?(%{ iyr: iyr }, :iyr), do: string_num_between?(iyr, 2010, 2020)
  def valid?(%{ eyr: eyr }, :eyr), do: string_num_between?(eyr, 2020, 2030)
  def valid?(%{ hgt: hgt }, :hgt), do: valid_height?(Integer.parse(hgt, 10))
  def valid?(%{ hcl: hcl }, :hcl), do: Regex.match?(~r/\A#[0-9a-f]{6}\z/, hcl)
  def valid?(%{ ecl: ecl }, :ecl), do: Enum.member?(@valid_ecls, ecl)
  def valid?(%{ pid: pid }, :pid), do: Regex.match?(~r/\A[0-9]{9}\z/, pid)

  def valid?(_, :cid),             do: true

  def valid_height?({ h, "cm" }), do: num_between?(h, 150, 193)
  def valid_height?({ h, "in" }), do: num_between?(h, 59, 76)
  def valid_height?({ _, "" }),   do: false

  defp string_num_between?(string, min, max) do
    string
    |> Integer.parse(10)
    |> num_between?(min, max)
  end

  defp num_between?(:error, _, _), do: false
  defp num_between?({ n, _ }, min, max), do: num_between?(n, min, max)
  defp num_between?(n, min, max), do: n >= min and n <= max
end
