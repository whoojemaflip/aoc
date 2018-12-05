require_relative "maze_builder"
require_relative "maze_solver"

maze = MazeBuilder.new(52, 52, 1364).plot
solver = MazeSolver.new(maze, 1, 1)
# solver.solve(31, 39)
# puts solver.best_distance
# MazeBuilder.print(solver.best_maze)
solver.solve_for_locations_visited(50)
puts
puts solver.locations_visited
