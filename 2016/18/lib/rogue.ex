defmodule Rogue do

  def puzzle_input do
    "^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^"
  end

  def part_1 do
    puzzle_input |> run(40)
  end

  def part_2 do
    puzzle_input |> run(400000)
  end

  @doc """
    Rogue.run(".^^.^.^^^^", 10)
    38
  """
  def run(first_row, number_of_rows) do
    first_row |> generate(number_of_rows)
  end


  def count_of_safe_tiles(row), do: count_characters(row, ".")

  @doc """
    iex> Rogue.count_characters("ooo...ooo", ".")
    3
  """
  def count_characters(str, char), do: count_characters(str, char, 0)
  def count_characters("", _, count), do: count
  def count_characters(<< first::bytes-size(1) >> <> rest, char, acc) do
    if first == char do
      count_characters(rest, char, acc + 1)
    else
      count_characters(rest, char, acc)
    end
  end


  def generate(starter_row, count), do: generate(starter_row, count, 0)
  def generate(_, 0, acc), do: acc
  def generate(previous_row, count, acc) do
    previous_row |> next_row |> generate(count - 1, acc + count_of_safe_tiles(previous_row))
  end

  @doc """
    iex> Rogue.next_row("..^^.")
    ".^^^^"
  """
  def next_row(line) do
    "." <> line <> "."
      |> chunk(3, 1)
      |> Enum.map(&(plot(&1)))
      |> Enum.join
  end


  def plot("^^."), do: "^"
  def plot(".^^"), do: "^"
  def plot("^.."), do: "^"
  def plot("..^"), do: "^"
  def plot(_), do: "."

  @doc """
    iex> Rogue.chunk("1234567", 4, 2)
    ["1234", "3456", "567"]
  """
  def chunk("", _, _), do: []
  def chunk(str, count, step) do
    remainder = String.slice(str, step..-1)
    result = case String.length(remainder) > count do
      true -> chunk(remainder, count, step)
      false -> [remainder]
    end
    [String.slice(str, 0..count - 1) | result]
  end
end
