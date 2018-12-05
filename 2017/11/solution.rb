require 'matrix'

def assert_equal(a, b)
  raise unless a == b
end

def step_vector(step)
  case step
  when 'ne'
    Vector[1, -1]
  when 'n'
    Vector[0, -1]
  when 'nw'
    Vector[-1, 0]
  when 'se'
    Vector[1, 0]
  when 's'
    Vector[0, 1]
  when 'sw'
    Vector[-1, 1]
  end
end

def walk_hex_grid(directions)
  pos = Vector[0, 0]

  directions.split(',').each do |step|
    pos += step_vector(step)
  end

  pos.map(&:abs).max
end

def max_walk(directions)
  pos = Vector[0, 0]
  distances = []

  directions.split(',').each do |step|
    pos += step_vector(step)
    distances << pos.map(&:abs).max
  end

  distances.max
end

assert_equal walk_hex_grid('ne,ne,ne'), 3
assert_equal walk_hex_grid('ne,ne,sw,sw'), 0
assert_equal walk_hex_grid('ne,ne,s,s'), 2
assert_equal walk_hex_grid('se,sw,se,sw,sw'), 3

input = File.read('input.txt').strip
puts "Part 1: #{walk_hex_grid(input)}"
puts "Part 2: #{max_walk(input)}"
