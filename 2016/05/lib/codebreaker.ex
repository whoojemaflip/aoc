defmodule Codebreaker do

  # @doc """
  #   iex> Codebreaker.find_passphrase("abc")
  #   "18f47a30"
  # """
  # def find_passphrase(str), do: find_passphrase(str, 8, 0, "")
  # def find_passphrase(_, 0, _, out), do: String.downcase(out)
  # def find_passphrase(str, count, tally, out) do
  #   {hash, tally} = find_next_matching_increment({str, tally})
  #   find_passphrase(str, count - 1, tally + 1, out <> String.at(hash, 5) )
  # end

  @doc """
    iex> Codebreaker.indexed_passphrase("abc")
    "05ace8e3"
  """
  def indexed_passphrase(str), do: indexed_passphrase(str, 8, 0, create_string(8))
  def indexed_passphrase(_, 0, _, out), do: String.downcase(out)
  def indexed_passphrase(str, count, tally, out) do
    IO.puts out
    {hash, tally} = find_next_matching_increment({str, tally})
    case index(hash) do
      {:ok, ind} ->
        indexed_passphrase(str, count, tally + 1, replace_char(out, ind, char(hash)) )
      {:nope} ->
        indexed_passphrase(str, count, tally + 1, out )
    end
  end

  def index(hash) do
    pos = String.at(hash, 5)

    if String.match?(pos, ~r/[01234567]/) do
      {:ok, String.to_integer(pos)}
    else
      {:nope}
    end
  end

  def char(hash), do: String.at(hash, 6)

  @doc """
    iex> Codebreaker.replace_char("abc", 2, "z")
    "abz"
  """
  def replace_char(str, index, char) do
    existing_char = String.codepoints(str) |> Enum.at(index)
    case existing_char do
      "_" ->
        String.codepoints(str) |> List.replace_at(index, char) |> Enum.join
      _ ->
        str
    end
  end

  @doc """
    iex> Codebreaker.create_string(3)
    "___"
  """
  def create_string(len), do: create_string(len, "")
  def create_string(0, str), do: str
  def create_string(len, str), do: create_string(len - 1, str <> "_")

  @doc """
    iex> Codebreaker.find_next_matching_increment("abc")
    {"00000155F8105DFF7F56EE10FA9B9ABD", 3231929}
  """
  def find_next_matching_increment({str, count}) do
    case hash_starts_with_five_zeros?(str <> Integer.to_string(count)) do
      {:nope, _} ->
        find_next_matching_increment({str, count + 1})
      {:ok, hash} ->
        {hash, count}
    end
  end
  def find_next_matching_increment(str), do: find_next_matching_increment({str, 0})

  @doc """
    iex> Codebreaker.hash_starts_with_five_zeros?("abc3231929")
    {:ok, "00000155F8105DFF7F56EE10FA9B9ABD"}
    iex> Codebreaker.hash_starts_with_five_zeros?("foo")
    {:nope, "ACBD18DB4CC2F85CEDEF654FCCC4A4D8"}
  """
  def hash_starts_with_five_zeros?(str) do
    hash = encode(str)
    case hash do
      "00000" <> _ -> {:ok, hash}
      _ -> {:nope, hash}
    end
  end

  @doc """
    iex> Codebreaker.encode("abc")
    "900150983CD24FB0D6963F7D28E17F72"
  """
  def encode(str) do
    :crypto.hash(:md5, str) |> Base.encode16
  end
end
