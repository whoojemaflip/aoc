defmodule Decompressor do

  def app, do: run("data.txt")

  @doc """
    iex> Decompressor.run("test.txt")
    20
  """
  def run(filename), do: filedata(filename) |> decompress


  @doc """
    iex> Decompressor.decompress("ADVENT")
    6
    iex> Decompressor.decompress("A(1x5)BC")
    7
    iex> Decompressor.decompress("(3x3)XYZ")
    9
    iex> Decompressor.decompress("(27x12)(20x12)(13x14)(7x10)(1x12)A")
    241920
    iex> Decompressor.decompress("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
    445
    iex> Decompressor.decompress("X(8x2)(3x3)ABCY")
    20
  """
  def decompress(str), do: decompress(str, 0)
  def decompress("", result), do: result
  def decompress(str, acc) do
    case next_chunk_details(str) do
      %{preamble: p, multiplier: m, chunk: chunk, remainder: r} ->
        data = chunk |> decompress
        decompress(r, acc + String.length(p) + (data * m))
      %{preamble: p} -> acc + String.length(p)
      nil -> acc
    end
  end

  @doc """
    iex> Decompressor.next_chunk_details("ABCD(3x987)EFGH")
    %{preamble: "ABCD", multiplier: 987, chunk: "EFG", remainder: "H"}
  """
  def next_chunk_details(str) do
    regex = ~r/\A(?<preamble>[^(]+?)?(\(?(?<char_count>\d+)x(?<multiplier>\d+)\)(?<remainder>.*))?\Z/
    # IO.puts str
    # IO.inspect Regex.named_captures(regex, str)

    case Regex.named_captures(regex, str) do
      %{"preamble" => p, "char_count" => "", "multiplier" => "", "remainder" => ""} ->
        %{preamble: p}
      %{"preamble" => p, "multiplier" => m, "char_count" => c, "remainder" => r} ->
        char_count = String.to_integer(c)
        chunk = String.slice(r, 0..char_count-1)
        remainder = String.slice(r, char_count..-1)
        %{preamble: p, multiplier: String.to_integer(m), chunk: chunk, remainder: remainder}
      nil -> nil
    end
  end

  def filedata(filename) do
    Path.join("data", filename) |> File.read!
  end
end
