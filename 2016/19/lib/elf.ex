defmodule Elf do
  @doc """
    iex> Elf.setup(5) |> Elf.loop
    3
  """
  def loop(elves), do: loop(elves, [])
  def loop([giver | [_ | rest]], acc), do: loop(rest, [giver | acc])
  def loop([giver], acc), do: [giver | Enum.reverse(acc)] |> loop([])
  def loop([], [last_elf]), do: last_elf
  def loop([], acc), do: Enum.reverse(acc) |> loop([])


  def get_sequence(0), do: "fin"
  def get_sequence(count) do
    slow_circle(count)
    get_sequence(count - 1)
  end

  @doc """
    iex> Elf.slow_circle(5)
    2
    iex> Elf.slow_circle(6)
    3
  """
  def slow_circle(num) when is_integer(num), do: setup(num) |> slow_circle(num, num)
  def slow_circle([winner, loser], _, start) do
    IO.puts "#{start}, #{winner}"
  end
  def slow_circle(rem, 0, _), do: IO.inspect(rem)
  def slow_circle([head | tail], pos, start) do
    o = opposite(pos, Enum.count(tail  ))
    slow_circle( [head] ++ List.delete_at(tail, o), pos + 1, start)
  end

  def opposite(num, size) do
    case rem((num + div(size, 2)), size) do
      0 -> size
      x -> x
    end
  end

  def setup(num), do: Enum.to_list(1..num)
end
