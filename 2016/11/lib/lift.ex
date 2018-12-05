defmodule Lift do

  @doc """
    iex> Lift.test_solver
    11
  """
  def test_solver, do: depth_first_solver(test)

  def solver, do: depth_first_solver(data)

  def depth_first_solver(floors), do: depth_first_solver(floors, [], 20)
  def depth_first_solver(state, path, best_solution) do
    print(state)
    if Enum.count(path) >= best_solution do
      best_solution
    else
      if complete?(state) do
        Enum.count(path) + 1
      else
        state
          |> possible_moves
          |> Enum.map(fn(m) -> depth_first_solver(move(state, m), path ++ [state], best_solution) end)
          |> Enum.min
      end
    end
  end

  @doc """
    iex> Lift.test |> Lift.complete?
    false
    iex> Lift.complete?([[], [], [], [:things]])
    true
  """
  def complete?(floors) do
    Enum.at(floors, 0) == []
      && Enum.at(floors, 1) == []
      && Enum.at(floors, 2) == []
  end

  @doc """
    iex> Lift.move([[:elevator, %{microchip: :hydrogen}], []], {%{microchip: :hydrogen}, 0, 1})
    [[], [:elevator, %{microchip: :hydrogen}]]
  """
  def move(floors, {item, old_floor_number, new_floor_number}) do
    floors
      |> move_elevator(old_floor_number, new_floor_number)
      |> move_item(item, old_floor_number, new_floor_number)
  end

  def move_item(floors, item, old, new) do
    floors |> remove_item(item, old) |> add_item(item, new)
  end

  def move_elevator(floors, old, new) do
    floors |> remove_item(:elevator, old) |> add_item(:elevator, new)
  end

  @doc """
    iex> Lift.add_item([[], [], []], :elevator, 1)
    [[], [:elevator], []]
  """
  def add_item(floors, item, floor) do
    case item do
      :elevator ->
        floors |> List.replace_at(floor,
          [ :elevator ] ++ ( floors |> Enum.at(floor) )
        )
      _ ->
        floors |> List.replace_at(floor,
          ( floors |> Enum.at(floor) ) ++ [ item ]
        )
    end
  end

  @doc """
    iex> Lift.remove_item([[], [:elevator], []], :elevator, 1)
    [[], [], []]
  """
  def remove_item(floors, item, floor) do
    floors |> List.replace_at(floor,
      floors
        |> Enum.at(floor)
        |> Enum.filter(fn(x) -> x != item end)
      )
  end

  def step(maze, [x, y]) do
    maze |> List.replace_at(y,
      maze
        |> Enum.at(y)
        |> String.codepoints
        |> List.replace_at(x, "O")
        |> Enum.join
      )
  end

  @doc """
    iex> Lift.possible_moves([[:elevator, %{microchip: :hydrogen}], []])
    [{%{microchip: :hydrogen}, 0, 1}]
  """
  def possible_moves(floors) do
    id = current_floor(floors)
    items = current_items(floors)
    max_id = Enum.count(floors) - 1

    items
      |> safe_to_remove
      |> Enum.reduce([], fn(item, acc) -> acc ++ [{item, id, id - 1}, {item, id, id + 1}] end)
      |> Enum.filter(fn({_, _, new_id}) -> (new_id >= 0 && new_id <= max_id) end)
  end

  def current_items(floors) do
    id = current_floor(floors)
    floors |> Enum.at(id) |> Enum.slice(1..-1)
  end

  @doc """
    Lift.safe_to_remove([%{microchip: :hydrogen}, %{microchip: :lithium}])
    [%{microchip: :hydrogen}, %{microchip: :lithium}]
  """
  def safe_to_remove(floor), do: safe_to_remove(floor, [])
  def safe_to_remove([], result), do: result
  def safe_to_remove([head|tail], result) do
    if safe?(tail) do
      safe_to_remove(tail, result ++ [head])
    else
      safe_to_remove(tail, result)
    end
  end

  @doc """
    iex> Lift.test |> Lift.current_floor
    0
  """
  def current_floor(floors) do
    Enum.find_index(floors, fn(floor) -> Enum.at(floor, 0) == :elevator end)
  end

  @doc """
    Lift.safe?([%{microchip: :hydrogen}, %{microchip: :lithium}])
    true
    Lift.safe?([%{microchip: :hydrogen}, %{generator: :hydrogen}])
    true
    Lift.safe?([%{generator: :lithium}, %{microchip: :hydrogen}])
    false
    Lift.safe?([%{generator: :lithium}, %{microchip: :hydrogen}, %{microchip: :lithium}])
    false
  """
  def safe?(floor) do
    microchips(floor)
      |> Enum.map(&(shielded?(floor, &1)))
      |> Enum.all?(&(&1))
  end

  def microchips(floor), do: microchips(floor, [])
  def microchips([], result), do: result
  def microchips([head|tail], acc) do
    case head do
      %{microchip: element} -> microchips tail, acc ++ microchip(element)
      %{generator: _} -> microchips tail, acc
    end
  end

  def shielded?(list, material), do: Enum.member?(list, generator(material))

  def print(floors) do
    IO.puts ""
    max = Enum.max_by(floors, fn(fl) -> Enum.count(fl) end)
    count = Enum.count(floors)
    floors |> Enum.reverse |> _print(floors, count, max)
  end
  def _print([], floors, _, _), do: floors
  def _print([h|t], floors, fl, width) do
    s = case Enum.at(h, 0) do
      :elevator -> "E F#{fl} " <> _print(Enum.slice(h, 1..-1))
      _ -> "  F#{fl} " <> _print(h)
    end
    IO.puts s
    _print(t, floors, (fl-1), width)
  end

  def _print(%{generator: thing}) do
    "G_" <> ( Atom.to_string(thing) |> String.slice(0..3) )
  end
  def _print(%{microchip: thing}) do
    "M_" <> ( Atom.to_string(thing) |> String.slice(0..3) )
  end
  def _print(floor), do: Enum.map(floor, &(_print(&1))) |> Enum.join(" ")


  def microchip(element), do: %{microchip: element}
  def generator(element), do: %{generator: element}

  def test do
    [
      [:elevator, %{microchip: :hydrogen}, %{microchip: :lithium}],
      [%{generator: :hydrogen}],
      [%{generator: :lithium}],
      []
    ]
  end

  def data do
    [
      [:elevator, generator(:thulium), microchip(:thulium), generator(:plutonium), generator(:strontium)],
      [microchip(:plutonium), microchip(:strontium)],
      [generator(:promethium), microchip(:promethium), generator(:ruthenium), microchip(:ruthenium)],
      []
    ]
  end
end
