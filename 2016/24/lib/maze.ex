defmodule Maze do
  def part_1, do: load("data.txt") |> distance_between_all_points |> write_to_disk("data/part1_graph.txt")

  def write_to_disk(points, filename) do
    {:ok, file} = File.open(filename, [:write])
    for {snode, enode, dist} <- points do
      IO.binwrite file, "#{snode} -> #{enode} (#{dist})\n"
    end
    File.close file
  end

  @doc """
    iex> Maze.test_data |> Maze.distance_between_all_points
    [{"0", "3", 10}, {"1", "3", 8}, {"2", "3", 2}, {"3", "4", 8},
    {"0", "4", 2}, {"1", "4", 4}, {"2", "4", 10}, {"0", "2", 8},
    {"1", "2", 6}, {"0", "1", 2}]
  """
  def distance_between_all_points(maze) do
    maze
      |> points_of_interest
      |> pairs
      |> Enum.map(&(Enum.sort(&1)))
      |> Enum.uniq
      |> Enum.map(&distance_between_two_points(&1, maze))
  end

  @doc """
    iex> Maze.distance_between_two_points([{"0", [1,1]}, {"2", [9, 1]}], Maze.test_data)
    {"0", "2", 8}
  """
  def distance_between_two_points([{a, pos}, {b, goal_pos}], maze) do
    dist = breadth_first_solver(maze, pos, goal_pos)
    {a, b, dist}
  end

  @doc """
    iex> Maze.adjacent_to_goal?([1, 2], [2, 2])
    true
    iex> Maze.adjacent_to_goal?([1, 2], [2, 1])
    false
  """
  def adjacent_to_goal?([x, y], [x1, y1]) do
    (abs(x - x1) + abs(y - y1)) < 2
  end

  @doc """
    iex> Maze.test_data |> Maze.breadth_first_solver([1,1], [9, 3])
    10
  """
  def breadth_first_solver(maze, start_pos, goal_pos) do
    if start_pos == goal_pos do
      0
    else
      maze |> step(start_pos) |> _breadth_first_solver(goal_pos, 0)
    end
  end

  def _breadth_first_solver(maze, goal_pos, depth) do
    moves = all_possible_moves(maze)
    if Enum.any?(moves, fn(pos) -> goal?(pos, goal_pos) end) do
      depth + 1
    else
      moves
        |> Enum.reduce(maze, fn(pos, acc) -> step(acc, pos) end)
        |> _breadth_first_solver(goal_pos, depth + 1)
    end
  end


  def print_maze(maze) do
    IO.puts ""
    print_maze(maze, maze)
  end

  def print_maze([], maze), do: maze
  def print_maze([h|t], maze) do
    IO.inspect(h)
    print_maze(t, maze)
  end

  def all_possible_moves(maze) do
    points_of_interest(maze, ~r{\AO\Z})
      |> Enum.map(fn({_, [x, y]}) -> [x, y] end)
      |> Enum.reduce([], fn(pos, acc) -> next_moves(maze, pos) ++ acc end)
  end

  @doc """
    iex> Maze.step(["###########", "#0.1.....2#", "#.#######.#", "#4.......3#", "###########"], [4, 1])
    ["###########", "#0.1O....2#", "#.#######.#", "#4.......3#", "###########"]
  """
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
    iex> Maze.pairs([1,2,3])
    [[3, 1], [3, 2], [2, 3], [2, 1], [1, 2], [1, 3]]
  """
  def pairs(list), do: pairs(list, Enum.count(list), [])
  def pairs(_, 0, result), do: result
  def pairs([h|t], iterations, result) do
    pairs t ++ [h], iterations - 1, Enum.map(t, fn(x) -> [h, x] end) ++ result
  end

  def next_moves(maze, [x, y]) do
    [[x-1, y], [x, y-1], [x+1, y], [x, y+1]]
      |> Enum.filter(fn(pos) -> traverseable?(maze, pos) end)
  end

  def goal?(pos, goal_pos), do: pos == goal_pos
  def traverseable?(maze, pos), do: Regex.match?(~r{[0-9\.]}, char_at_pos(maze, pos))
  def char_at_pos(maze, [x, y]), do: maze |> Enum.at(y) |> String.at(x)

  @doc """
    iex> Maze.points_of_interest(Maze.test_data)
    [{"0", [1, 1]}, {"1", [3, 1]}, {"2", [9, 1]}, {"4", [1, 3]}, {"3", [9, 3]}]
  """
  def points_of_interest(maze), do: points_of_interest(maze, 0, [], ~r{[0-9]})
  def points_of_interest(maze, pattern), do: points_of_interest(maze, 0, [], pattern)
  def points_of_interest([], _, result, _), do: result
  def points_of_interest([h|t], y_index, result, pattern) do
    points_of_interest(t, y_index + 1, result ++ _points_of_interest(h, y_index, pattern), pattern)
  end

  def _points_of_interest(str, y_index, pattern), do: _points_of_interest(str, pattern, 0, y_index, [])
  def _points_of_interest("", _, _, _, result), do: Enum.reverse(result)
  def _points_of_interest(str, pattern, x_index, y_index, acc) do
    if Regex.match?(pattern, String.first(str)) do
      res = { String.first(str), [x_index, y_index] }
      _points_of_interest String.slice(str, 1..-1), pattern, x_index + 1, y_index, [res | acc]
    else
      _points_of_interest String.slice(str, 1..-1), pattern, x_index + 1, y_index, acc
    end
  end

  def time, do: :os.system_time(:millisecond)
  def test_data, do: load("test.txt")

  @doc """
    iex> Maze.load("test.txt")
    ["###########", "#0.1.....2#", "#.#######.#", "#4.......3#", "###########"]
  """
  def load(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
