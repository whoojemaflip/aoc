defmodule Vault do

  @doc """
    iex> Vault.shortest_path("ihgpwlah")
    "DDRRRD"
    iex> Vault.shortest_path("kglvqrro")
    "DDUDRLRRUDRD"
    iex> Vault.shortest_path("ulqzkmiv")
    "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  """
  def shortest_path(str) do
    step(str) |> sort_by_string_length_asc |> Enum.at(0)
  end

  def longest_path(str) do
    step(str) |> sort_by_string_length_asc |> Enum.at(-1)
  end

  def sort_by_string_length_asc(strings) do
    Enum.sort(strings, &(String.length(&1) < String.length(&2)))
  end

  def step(str), do: step(str, "", {0, 0})
  def step(salt, trail, {3, 3}), do: [trail]
  def step(salt, trail, {x, y}) do
    hsh = hash(salt <> trail)
    down = explore_down(hsh, salt, trail, {x, y})
    right = explore_right(hsh, salt, trail, {x, y})
    up = explore_up(hsh, salt, trail, {x, y})
    left = explore_left(hsh, salt, trail, {x, y})

    down ++ right ++ up ++ left
  end

  def explore_down(hsh, salt, trail, {x, y}) do
    if down?(hsh, {x, y}) do
      step(salt, trail <> "D", {x, y + 1})
    else
      []
    end
  end

  def explore_right(hsh, salt, trail, {x, y}) do
    if right?(hsh, {x, y}) do
      step(salt, trail <> "R", {x + 1, y})
    else
      []
    end
  end

  def explore_up(hsh, salt, trail, {x, y}) do
    if up?(hsh, {x, y}) do
      step(salt, trail <> "U", {x, y - 1})
    else
      []
    end
  end

  def explore_left(hsh, salt, trail, {x, y}) do
    if left?(hsh, {x, y}) do
      step(salt, trail <> "L", {x - 1, y})
    else
      []
    end
  end

  def up?(hash, {_, y}), do: in_bounds?(y) && door_open?(hash, 0)
  def down?(hash, {_, y}), do: in_bounds?(y) && door_open?(hash, 1)
  def left?(hash, {x, _}), do: in_bounds?(x) && door_open?(hash, 2)
  def right?(hash, {x, _}), do: in_bounds?(x) && door_open?(hash, 3)

  def door_open?(str, pos), do: Regex.match? ~r{[b-f]}, String.at(str, pos)

  def hash(str), do: Base.encode16(:erlang.md5(str), case: :lower)

  def in_bounds?(x) do
    x >= 0 && x <= 3
  end
end
