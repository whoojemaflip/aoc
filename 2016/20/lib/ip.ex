defmodule Ip do

  @doc """
    iex> Ip.get_data("test.txt") |> Ip.all_viable(9)
    [3, 9]
  """
  def all_viable(ranges, max_int), do: all_viable(ranges, 0, [], max_int)
  def all_viable(_, max, acc, max_int) when max > max_int, do: Enum.sort(acc)
  def all_viable([], max, acc, max_int), do: all_viable([], max + 1, [max | acc], max_int)
  def all_viable([range|tail], max, acc, max_int) do
    first..last = range
    if Enum.member?(range, max) do
      all_viable(tail, last + 1, acc, max_int)
    else
      all_viable([range|tail], max + 1, [max | acc], max_int)
    end
  end


  @doc """
    iex> Ip.compress_ranges([0..3, 4..9, 5..9, 11..12])
    [0..9, 11..12]
  """
  def compress_ranges(sorted_ranges), do: compress_ranges(sorted_ranges, [], 0..0)
  def compress_ranges([], result, min..max), do: Enum.reverse [min..max | result]
  def compress_ranges([from..to | tail], result, min..max) do
    if from > (max + 1) do
      compress_ranges(tail, [min..max | result], from..to)
    else
      if to > max do
        compress_ranges(tail, result, min..to)
      else
        compress_ranges(tail, result, min..max)
      end
    end
  end

  def run do
    get_data("data.txt") |> all_viable(4294967295)
  end

  def get_data(filename), do: get_file_data(filename) |> parse |> compress_ranges

  @doc """
    iex> Ip.get_file_data("test.txt") |> Ip.parse
    [0..2, 4..7, 5..8]
  """
  def parse(lines), do: parse(lines, [])
  def parse([], result), do: Enum.sort(result)
  def parse([h | t], result), do: parse(t, [parse_line(h) | result])

  @doc """
    iex> Ip.parse_line("2749432077-2762094882")
    2749432077..2762094882
  """
  def parse_line(<< line::binary >>) do
    regex = ~r{\A(?<from>\d+?)-(?<to>\d+?)\Z}
    %{"from" => from, "to" => to} = Regex.named_captures(regex, line)
    String.to_integer(from)..String.to_integer(to)
  end


  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
