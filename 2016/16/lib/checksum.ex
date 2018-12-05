defmodule Checksum do
  def app do
    calc("11100010111110100", 272)
  end

  def part_two do
    calc("11100010111110100", 35651584)
  end

  @doc """
    iex> Checksum.calc("10000", 20)
    "01100"
  """
  def calc(input, length) do
    curve(input, length) |> checksum
  end

  @doc """
    iex> Checksum.checksum("110010110100")
    "100"
    iex> Checksum.checksum("10000011110010000111")
    "01100"
  """
  def checksum(str), do: checksum(str, "")
  def checksum("", sum) do
    if sum |> String.length |> is_odd do
      sum
    else
      checksum(sum)
    end
  end
  def checksum(str, sum) do
    bit_pair = String.slice(str, 0..1)
    out = case same?(bit_pair) do
      true -> "1"
      false -> "0"
    end
    checksum(String.slice(str, 2..-1), sum <> out)
  end

  @doc """
    iex> Checksum.same?("00")
    true
    iex> Checksum.same?("10")
    false
  """
  def same?(bit_pair) do
    bit_count = String.codepoints(bit_pair)
      |> Enum.chunk_by(fn(x) -> x end)
      |> Enum.count

    bit_count == 1
  end

  @doc """
    iex> Checksum.is_odd(1)
    true
    iex> Checksum.is_odd(1234)
    false
  """
  def is_odd(num), do: rem(num, 2) == 1

  @doc """
    iex> Checksum.curve("1", 3)
    "100"
    iex> Checksum.curve("0", 3)
    "001"
    iex> Checksum.curve("11111", 11)
    "11111000000"
    iex> Checksum.curve("111100001010", 25)
    "1111000010100101011110000"
    iex> Checksum.curve("10000", 20)
    "10000011110010000111"
  """
  def curve(a, length) do
    if String.length(a) < length do
      b = reverse(a) |> invert
      curve(a <> "0" <> b, length)
    else
      String.slice(a, 0..length-1)
    end
  end

  @doc """
    iex> Checksum.invert("00110")
    "11001"
  """
  def invert(str) do
    String.replace(str, ~r/0/, "x")
      |> String.replace(~r/1/, "0")
      |> String.replace(~r/x/, "1")
  end

  @doc """
    iex> Checksum.reverse("111000")
    "000111"
  """
  def reverse(str) do
    String.reverse(str)
  end
end
