defmodule Disks do

  @doc """
    iex> Disks.app("test.txt")
    5
  """
  def app(filename) do
    get_file_data(filename) |> parse |> solver
  end


  def solver(discs), do: solver(discs, 0)
  def solver(discs, time) do
    if solve_for_start_time(discs, time + 1) do
      time
    else
      solver(discs, time + 1)
    end
  end

  @doc """
    iex> Disks.solve_for_start_time([%{disc: 3, positions: 19, start: 17}], 4)
    false
    iex> Disks.solve_for_start_time([%{disc: 3, positions: 19, start: 17}], 2)
    true
  """
  def solve_for_start_time([], _), do: true
  def solve_for_start_time([head|tail], time) do
    if disc_position(head, time) do
      solve_for_start_time(tail, time + 1)
    else
      false
    end
  end

  @doc """
    iex> Disks.disc_position(%{disc: 1, positions: 5, start: 4}, 6)
    true
    iex> Disks.disc_position(%{disc: 2, positions: 2, start: 1}, 7)
    true
    iex> Disks.disc_position(%{disc: 1, positions: 5, start: 4}, 1)
    true
    iex> Disks.disc_position(%{disc: 2, positions: 2, start: 1}, 2)
    false
    iex> Disks.disc_position(%{disc: 3, positions: 19, start: 17}, 2)
    true
  """
  def disc_position(%{disc: disc, positions: positions, start: start}, time) do
    rem(start + time, positions) == 0
  end

  @doc """
    iex> Disks.parse(["Disc #3 has 19 positions; at time=0, it is at position 17."], [])
    [%{disc: 3, positions: 19, start: 17}]
  """
  def parse(data), do: parse(data, [])
  def parse([], result), do: result
  def parse([line|tail], result) do
    regex = ~r/\ADisc #(?<disc>\d+) has (?<positions>\d+) positions; at time=0, it is at position (?<start>\d+)\.\Z/
    res = Regex.named_captures(regex, line)

    disc = String.to_integer(res["disc"])
    positions = String.to_integer(res["positions"])
    start = String.to_integer(res["start"])

    parse tail, result ++ [%{disc: disc, positions: positions, start: start}]
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
