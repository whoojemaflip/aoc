defmodule Permutations do
  def of([]) do
    [[]]
  end

  def of(list) do
    for h <- list, t <- of(list -- [h]), do: [h | t]
  end
end

defmodule Scramble do

  def part_1, do: run("data.txt", "abcdefgh")

  def part_2 do
    program = get_file_data("data.txt")
    permutations("abcdefgh") |> _part_2(program, "fbgdceah")
  end

  def _part_2([head|tail], program, passwd) do
    if _run(program, head) == passwd do
      head
    else
      IO.puts head
      _part_2(tail, program, passwd)
    end
  end

  @doc """
    iex> Scramble.permutations("abc")
    ["abc", "acb", "bac", "bca", "cab", "cba"]
  """
  def permutations(str) do
    String.codepoints(str)
      |> Permutations.of
      |> Enum.map(&(Enum.join(&1)))
  end

  @doc """
    iex> Scramble.run("test.txt", "abcde")
    "decab"
  """
  def run(filename, str), do: get_file_data(filename) |> _run(str)
  def _run([], str), do: str
  def _run([head|tail], str), do: _run(tail, run_line(head, str))

  def run_line(line, str) do
    str
      |> _swap_letter(line)
      |> _swap_positions(line)
      |> _rotate_left(line)
      |> _rotate_right(line)
      |> _rotate_from_position_of_x(line)
      |> _reverse_positions(line)
      |> _move_position(line)
  end

  @doc """
    iex> Scramble._swap_positions("abcde", "swap position 4 with position 0")
    "ebcda"
  """
  def _swap_positions(str, line) do
    case Regex.named_captures(~r{\Aswap position (?<x>\d+) with position (?<y>\d+)\Z}, line) do
      nil -> str
      %{"x" => x, "y" => y} -> swap_positions str, String.to_integer(x), String.to_integer(y)
    end
  end

  @doc """
    iex> Scramble._swap_letter("ebcda", "swap letter d with letter b")
    "edcba"
  """
  def _swap_letter(str, line) do
    case Regex.named_captures(~r{\Aswap letter (?<x>.) with letter (?<y>.)\Z}, line) do
      nil -> str
      %{"x" => x, "y" => y} -> swap_letter(str, x, y)
    end
  end

  @doc """
    iex> Scramble._rotate_left("abcde", "rotate left 1 step")
    "bcdea"
  """
  def _rotate_left(str, line) do
    case Regex.named_captures(~r{\Arotate left (?<x>\d+) step[s]?\Z}, line) do
      nil -> str
      %{"x" => x} -> rotate_left str, String.to_integer(x)
    end
  end

  @doc """
    iex> Scramble._rotate_right("abcde", "rotate right 0 steps")
    "abcde"
  """
  def _rotate_right(str, line) do
    case Regex.named_captures(~r{\Arotate right (?<x>\d+) step[s]?\Z}, line) do
      nil -> str
      %{"x" => x} -> rotate_right str, String.to_integer(x)
    end
  end

  @doc """
    iex> Scramble._rotate_from_position_of_x("abdec", "rotate based on position of letter b")
    "ecabd"
    iex> Scramble._rotate_from_position_of_x("ecabd", "rotate based on position of letter d")
    "decab"
  """
  def _rotate_from_position_of_x(str, line) do
    case Regex.named_captures(~r{\Arotate based on position of letter (?<x>.)\Z}, line) do
      nil -> str
      %{"x" => x} -> rotate_from_position_of_x str, x
    end
  end

  @doc """
    iex> Scramble._reverse_positions("edcba", "reverse positions 0 through 2")
    "cdeba"
  """
  def _reverse_positions(str, line) do
    case Regex.named_captures(~r{\Areverse positions (?<x>\d+) through (?<y>\d+)\Z}, line) do
      nil -> str
      %{"x" => x, "y" => y} -> reverse_positions str, String.to_integer(x), String.to_integer(y)
    end
  end

  @doc """
    iex> Scramble._move_position("bcdea", "move position 1 to position 4")
    "bdeac"
  """
  def _move_position(str, line) do
    case Regex.named_captures(~r{\Amove position (?<x>\d+) to position (?<y>\d+)\Z}, line) do
      nil -> str
      %{"x" => x, "y" => y} -> move_position str, String.to_integer(x), String.to_integer(y)
    end
  end


  @doc """
    swap position X with position Y means that the letters at indexes X and Y
    (counting from 0) should be swapped.

    iex> Scramble.swap_positions("abcdefg", 2, 5)
    "abfdecg"
    iex> Scramble.swap_positions("abc", 0, 2)
    "cba"
    iex> Scramble.swap_positions("abcde", 4, 0)
    "ebcda"
  """
  def swap_positions(str, x, y) do
    list = String.codepoints(str)
    letter_x = Enum.at(list, x)
    letter_y = Enum.at(list, y)
    list
      |> List.delete_at(x)
      |> List.insert_at(x, letter_y)
      |> List.delete_at(y)
      |> List.insert_at(y, letter_x)
      |> Enum.join
  end

  @doc """
    swap letter X with letter Y means that the letters X and Y should be swapped
    (regardless of where they appear in the string).

    iex> Scramble.swap_letter("abcef", "b", "f")
    "afceb"
  """
  def swap_letter(str, x, y) do
    reg_a = Regex.compile!("#{x}")
    reg_b = Regex.compile!("#{y}")
    a = Regex.replace(reg_a, str, "🍍")
    b = Regex.replace(reg_b, a, x)
    Regex.replace(~r{🍍}, b, y)
  end

  @doc """
    rotate left/right X steps means that the whole string should be rotated;
    for example, one right rotation would turn abcd into dabc.

    iex> Scramble.rotate_left("abc", 2)
    "cab"
    iex> Scramble.rotate_left("abcde", 1)
    "bcdea"
  """
  def rotate_left(str, 0), do: str
  def rotate_left(str, x) do
    rotated_str = String.slice(str, 1..-1) <> String.at(str, 0)
    rotate_left(rotated_str, x - 1)
  end

  @doc """
    rotate left/right X steps means that the whole string should be rotated;
    for example, one right rotation would turn abcd into dabc.

    iex> Scramble.rotate_right("abc", 2)
    "bca"
  """
  def rotate_right(str, 0), do: str
  def rotate_right(str, x) do
    rotated_str = String.at(str, -1) <> String.slice(str, 0..-2)
    rotate_right(rotated_str, x - 1)
  end

  @doc """
    rotate based on position of letter X means that the whole string should be
    rotated to the right based on the index of letter X (counting from 0) as
    determined before this instruction does any rotations. Once the index is
    determined, rotate the string to the right one time, plus a number of times
    equal to that index, plus one additional time if the index was at least 4.

    iex> Scramble.rotate_from_position_of_x("abdec", "b")
    "ecabd"
  """
  def rotate_from_position_of_x(str, x) do
    pos = String.codepoints(str) |> Enum.find_index(fn(y) -> y == x end)
    if pos >= 4 do
      rotate_right(str, pos + 2)
    else
      rotate_right(str, pos + 1)
    end
  end

  @doc """
    reverse positions X through Y means that the span of letters at indexes X through Y
    (including the letters at X and Y) should be reversed in order.

    iex> Scramble.reverse_positions("edcba", 0, 4)
    "abcde"
  """
  def reverse_positions(str, x, y) do
    {first, second} = min_max(x, y)

    beginning = case (first == 0) do
      true -> ""
      false -> String.slice(str, 0..first-1)
    end

    reverseable_bit = String.slice(str, first..second)
    end_str = String.slice(str, second + 1..-1)

    beginning <> String.reverse(reverseable_bit) <> end_str
  end

  @doc """
    move position X to position Y means that the letter which is at index X should
    be removed from the string, then inserted such that it ends up at index Y.

    iex> Scramble.move_position("bcdea", 1, 4)
    "bdeac"
  """
  def move_position(str, x, y) do
    letter = String.at(str, x)
    String.codepoints(str)
      |> List.delete_at(x)
      |> List.insert_at(y, letter)
      |> Enum.join
  end

  @doc """
    sort the two arguments
  """
  def min_max(x, y) when x < y, do: {x, y}
  def min_max(x, y), do: {y, x}

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
