require 'matrix'

class Spiral 
  def self.part_1(num)
    position = Matrix[[0, 0]]
    direction = Matrix[[1, 0]]
    rotation = Matrix[[0, -1], [1, 0]]
    distance = 1
    count = 1

    while count < num do
      distance.times do
        position += direction
        count += 1
        break if count == num
      end

      direction = direction * rotation
      distance += 1 if direction == Matrix[[-1, 0]] || direction == Matrix[[1, 0]]
    end

    position.reduce(0) { |total, value| total + value.abs }
  end

  def self.part_2(num)
    grid = {0 => {0 => 1}}
    position = Matrix[[0, 0]]
    direction = Matrix[[1, 0]]
    rotation = Matrix[[0, -1], [1, 0]]
    distance = 1
    sum = 1

    get_x = -> { position.row(0)[0] }
    get_y = -> { position.row(0)[1] }

    get_grid_value = lambda do |x, y|
      grid.fetch(x, {}).fetch(y, 0)
    end

    calc_sum = lambda do
      s = 0
      x = get_x.call
      y = get_y.call

      s += get_grid_value.(x + 1, y)
      s += get_grid_value.(x + 1, y - 1)
      s += get_grid_value.(x, y - 1)
      s += get_grid_value.(x - 1, y - 1)
      s += get_grid_value.(x - 1, y)
      s += get_grid_value.(x - 1, y + 1)
      s += get_grid_value.(x, y + 1)
      s += get_grid_value.(x + 1, y + 1)

      s
    end

    set_grid_value = lambda do |val|
      grid[get_x.call] ||= {}
      grid[get_x.call][get_y.call] = val
    end

    while sum <= num do
      distance.times do
        position += direction
        sum = calc_sum.call
        set_grid_value.(sum)
        break if sum > num
      end

      direction = direction * rotation
      distance += 1 if direction == Matrix[[-1, 0]] || direction == Matrix[[1, 0]]
    end

    sum
  end
end
