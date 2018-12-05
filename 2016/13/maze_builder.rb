class MazeBuilder
  def initialize(width = 10, height = 10, input = 10)
    @width = width
    @height = height
    @input = input
    @maze = [[]]
    plot
  end

  def calc(x, y)
    s1 = (x * x) + (3 * x) + (2 * x * y) + y + (y * y)
    s2 = s1 + @input
    s3 = s2.to_s(2)
    s4 = s3.count("1")
  end

  def plot
    (0..@height - 1).each do |y|
      @maze[y] = []
      (0..@width - 1).each do |x|
        @maze[y] << (calc(x, y).odd? ? "#" : ".")
      end
    end
    @maze
  end

  def print
    self.print(@maze)
  end

  def self.print(maze)
    puts
    maze.each do |row|
      out = ""
      row.each { |cell| out << cell }
      puts out
    end
  end
end
