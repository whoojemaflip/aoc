class MazeSolver
  WALL = "#"
  FLOOR = "."
  TRAIL = "O"
  GOAL = "X"

  def initialize(maze, start_x = 1, start_y = 1)
    @maze = maze
    @start_x = start_x
    @start_y = start_y
    @min_distance = Float::INFINITY
    @min_solution = @maze
  end

  def best_maze
    @min_solution
  end

  def best_distance
    @min_distance
  end

  def solve(goal_x = 7, goal_y = 4)
    @maze[goal_y][goal_x] = GOAL
    depth_first_search(@maze, @start_x, @start_y)
  end

  def solve_for_locations_visited(max_moves = 50)
    @moves = []
    bounded_search(@maze, @start_x, @start_y, max_moves)
    @moves.uniq!
  end

  def locations_visited
    @moves.count
  end

  def bounded_search(maze, x, y, remaining_moves)
    @moves << [x, y]
    if remaining_moves > 0
      maze[y][x] = TRAIL
      valid_moves(maze, x, y).each do |move|
        bounded_search(copy_maze(maze), move[0], move[1], remaining_moves - 1)
      end
    end
  end

  def depth_first_search(maze, x, y)
    maze[y][x] = TRAIL
    if immediately_solveable?(maze, x, y)
      keep_if_best_solution(maze)
    else
      valid_moves(maze, x, y).each do |move|
        depth_first_search(copy_maze(maze), move[0], move[1])
      end
    end
  end

  def valid_moves(maze, x, y)
    dirs = []
    adjacencies(x, y).each do |arr|
      dirs << arr if floor?(maze, arr[0], arr[1])
    end
    dirs
  end

  def copy_maze(maze)
    Marshal.load(Marshal.dump(maze))
  end

  def keep_if_best_solution(maze)
    if trail_length(maze) + 1 < @min_distance
      @min_distance = trail_length(maze) + 1
      @min_solution = maze
    end
  end

  def immediately_solveable?(maze, x, y)
    adjacencies(x, y).any? do |move|
      goal?(maze, move[0], move[1])
    end
  end

  def trail_length(maze)
    count = 0
    maze.each do |row|
      row.each { |cell| count += 1 if cell == TRAIL }
    end
    count
  end

  def goal?(maze, x, y)
    maze[y][x] == GOAL
  end

  def floor?(maze, x, y)
    maze[y][x] == FLOOR
  end

  def adjacencies(x, y)
    adj = []

    adj << [x - 1, y] if x > 0
    adj << [x + 1, y] if x < max_x
    adj << [x, y - 1] if y > 0
    adj << [x, y + 1] if y < max_y

    adj
  end

  def max_x
    @_max_x ||= @maze[0].size - 1
  end

  def max_y
    @_max_y ||= @maze.size - 1
  end
end
