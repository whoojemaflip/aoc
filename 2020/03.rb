def assert(fact)
  raise unless fact
end
require 'pry'

input = DATA.each_line.map(&:strip).map(&:chars)
test = %Q{
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
}.strip.each_line.map(&:strip).map(&:chars)

def toboggan(map, direction)
  x,y = [0,0]
  v_x, v_y = direction
  max_x = map.first.size
  max_y = map.size
  trees = 0

  while y < max_y
    x += v_x
    y += v_y

    x -= max_x if x >= max_x
    return trees if y >= max_y

    if map[y][x]=='#'
      trees += 1
    end
  end

  trees
end

def print_map(map)
  map.each.with_index do |row, i|
    row.each.with_index do |cell, j|
      print cell
    end
    print "\n"
  end
end

assert toboggan(test, [3, 1]) == 7
puts "Part 1: " + toboggan(input, [3, 1]).to_s

def part_2(map)
  toboggan(map, [1,1]) *
    toboggan(map, [3,1]) *
    toboggan(map, [5,1]) *
    toboggan(map, [7,1]) *
    toboggan(map, [1,2])
end

assert part_2(test) == 336
puts "Part 2: " + part_2(input).to_s
__END__
.#..........#...#...#..#.......
.###...#.#.##..###..#...#...#..
#.....#................#...#.#.
#.....#..###.............#....#
......#.....#....#...##.....###
....#........#.#......##....#.#
..#.......##..#.#.#............
#.............#..#...#.#...#...
.#...........#.#....#..##......
......#..##..#....#....#...##..
....#.##.#####..#.##..........#
..#.#......#.#.#....#.....#....
...###.##......#..#.#...#...#..
...#..#.#..#..#.......#........
...#....#..#...........#.#.....
....#.........###.#....#...#...
....#..##.....#.##....##.#.....
........#.#.#.....#........#...
..#..#.....#.#...#.#...#.#.....
....#..........#....#....#...##
.##...#..#...##....#..#.#....#.
.#....##..#...#................
..#.###.........#.###.....#....
....#..#.......###.#...........
#...#...#.#...........#.#......
.#..#.......##.....##...#......
....####.#..#.#.#...........#..
.##...#..#..#.#....##.....#..##
...#......##....#...#.#.###....
##.#...........#.........#...#.
...........#...#...........##..
.....#....#...........#........
...#..#.........#...#....#.##..
.....##.........#...#........##
....#....#..#.#...#...##.#.....
...#.#..#...#...........#..#...
.....#.#.....#....#...#....#...
.#.............#..##..........#
..........#......#..##.....###.
..#....#........#.#.....##...#.
#..#......#.#.##......#.#.##...
.....#..#.........#...#.#.#.#.#
#.#...#.......#.#..##.##.....##
.....#......##......#.......#..
#.....#...##.#.#........#......
#..........#.#...#.......#.....
..#..#........#........#.......
...#....#....#..####.#....#...#
#.............#.....##....#..#.
##....#.....###..##....#......#
#.....#...#.#.............#....
.#.#..##..##.#..#....#.#.#...#.
.#...#..#.....#..#.#.#..#...##.
..#.#.#.#.#.#....##...#........
.......##.....#..........#...#.
...#..#...#...........#....#...
.....#..#....#..#.##...#.......
..##..#.......#.#..#....#......
...#...............#.#..#......
....#........#...#....#...#.#..
...#...#..........##....##.#...
..###.#.##.............#..#.#.#
##.......##.#..#.#.#.....#.#.#.
..#####...#......##...#........
...#.##...#................#..#
..#......#...#....#.#..##..#...
#.#.........#............#.....
##.............#.#.....#......#
....#.......#..#..##....#.#....
...#...##....#.........#..#....
...####.....#...........#....#.
#.#........##....#..#..#...#...
....#.#.###..........#........#
#.#......#.....#.##....#.#...#.
#....##.#..##..#.#.............
.#.....##..#..................#
...#.#........#...#.#........#.
..#....#......#.....##........#
....#...#....#...#.....#.##....
...#........#.......##.........
.#.##......#......#....##......
.#...#...###.#............#..#.
.#...........#.#.#....#...#..#.
.#.....#....#.....#...#........
.#..#.....#............#.#.##.#
...###.#.............#..##.....
...#.#.##.#..#..........#..#...
.#.#.#....#..#...............##
.......#.#..#...#.#.#........#.
....#.#...#..##....#........#.#
..........#...#.......#..#....#
...###.....#.#....#.....##.....
#......#..#..#........#.#...#..
#......#....#..#.#.............
...#....#........#...#..#......
...#..###........#.#.........##
#......#.#..###..#........###..
.#.#......#.#..#.#.#.#.....#..#
#....#.....#..##.....#.........
....#......#...#..#..#.#.##.#..
........#.#...#...#..#...#.#..#
.....##........#...#....#...#..
....#...##..#........#....##.#.
...............#.....#......##.
..##.....#.....#.#.............
.....#.#...........##.#.....#..
.#..##..#.##.#...##.#....#....#
.##.....#.##......#....#..#..#.
.......#.##......#....#...#.#..
.#........#......#...##.#....#.
.........#..........#.......###
#.#.........#..#..#....#...#...
.......#.........#......#.#.#..
.......#...........#....#....#.
.###...##.#.#..........#...#..#
....#.....#...#..#.............
.......##........#..#.......#..
....##..#.#....#....#..#...#..#
..#.####.....#.........#.#....#
..............#.#..#.....#...#.
.....#.............#..........#
..##.#...#.....#....#.#....##..
.#...#.......#..####..#..#...#.
#..........#................##.
......##.....#.................
..##...#.#..........##.#...#...
....#.#.#.#...##...#...#...####
.............##..#.###...#.....
#.#....#.#..#..##........#..##.
.....#.#...............#.......
...#..##......#..##...........#
#..#....#...........##..#......
.##....#.#....###.......#..#...
.....#..#.#....##...#......#...
.#.........#####......#...#...#
.......#.#.....#.....#.......#.
#....#.......###.......#..#....
#......##.###...#.......#......
.......#...#......#....#..#....
.#.####.......#...#.##.........
................##.#......#....
......##....#.#......#......#..
....##...##....#.........#.....
......#.#..............##.#...#
....#.#......#.#.............#.
.#.#..####...#................#
....#.#.#.#......##...##......#
.....#.#..#......#....#......#.
..........#.#.....#.......#...#
..##......##.#...##.#......#..#
...#............#..#...###.....
.#.#..###..#.......##...#.....#
.#....#.#.......#.....##....#..
#.............###...##.#.#...#.
#........#.#........#.#...#.#.#
##..#.................#....#...
...#.#...#..#.#..##....#...#...
#.....#.......#..............#.
.......###...##..#.....#.......
#.#.........#..#.#.........#...
.#.#............#.....##.....#.
........#....#....#.......#....
...#.#....#..#.##....#.#......#
.#.....#.#..#...........#.#.#..
#......#..#......##.#.#.#.#..#.
.......#.#..#......#.#.#..#.#.#
..........#...#..........#.##..
.#.#..####.......#..........#..
......#.#.....#..#..#..#.....#.
.....##..#.#.#..#..#...#.....##
............#.#....#.#....#....
..............#..#...#...#.....
.....#......#.......#.....#....
..##....#..#...........#..##...
###...#.##..#.#...####....###..
..#.#.....#.........#....#..###
##...........##.............#..
....##..............#.........#
...#...##....#.#..#...##.....#.
..#..##...#.......#..#..#.....#
...#...#....####........##.#...
....#........#..#.#.........#..
.#..........#...#..#.#.#......#
....#.#.....#.........#....#...
...#....#...##.......#...#.....
....#..#.......#.##.##.##...#..
##....##........#........##....
.#.#..#...........#.....#...#..
...#.##...##..#...#...##.......
.....#..###................#.#.
...#........##.#....##.....#.##
...#...#..##...#...#.#...#.....
.#......#...#..#.##.......#...#
.....#.......###.##...#........
#.....#..#........##.##.#.##..#
....#..............##.##...#...
#..........#..................#
..##.......#..........#..#..##.
.#....###.#..#.........###....#
.#....#.##..............#.##.##
.#.##.#....#.......#.#......#..
.#............#.#.....#........
..#......#.......#.............
#.#...#........##...#.#......#.
....#.........#........##..#...
..........##.....#.#......#....
.##.#..#....#.......#...#...##.
.#................#...#.##.....
....###.......#..#..#.........#
.#.....#..##...###......#.....#
.#.##..........#..#..#........#
.......#.##..............#...##
#...#.#.#.......#..#......#.##.
.#....#.#......#...#..........#
.....#........##....#.##.....#.
.#....................#..#.#.#.
.....#.........#....#.......#.#
.....#.#..##..#.....#..#.......
...#..#..#...#.....#....#....#.
#.....#.#.#..........#..#.#.#..
.....##..##.....#.#..#.........
#.#..##....##......##...#.##..#
..##..#.....#..#..........##...
......#.#...#..#.......##.....#
..#.#.......#.#......#.........
.....#........##..#.....####.#.
.#.....#........#.......#..##..
......#...#....#.##...#.......#
..##..................#..#.....
.....###.#..##...#.............
...##...##...#......#....#....#
#........#.#..........##..#....
#........#....#..........#...#.
...##.#.##..#...##......#......
#........##....#.#..##.....#..#
...####......#..#......#.#.....
.#......#...#...#.#.....##....#
.....###..##..#...#..........##
##.##....#...#.................
...##.#.......#.###......#..#..
.....#.#.#.......#.......#..#.#
#...#...#.##..#....###.......#.
.#.#..##.....#....#...##.......
.....#..........#....#...#.##..
..........#....#...#...........
.#....#..#...#...#.......#....#
#..#..............#.....####.##
.......#....###....#....#.#.#..
###.#........##.#.......#......
#..#...#..#......#.............
#...###..#...#..#..##.#.###.#..
..#..#...##......##............
.#..#.......#..###..##...#.....
....#..#..##.#.#.....##...#.#.#
....#....#.....#..#....#.......
..##..#....#.#...##..#.........
.....#....#...........#.#......
...#........#.#..#..#......#..#
.#...##....#....#.#.##......#.#
..#...........#..###.##.....#..
.#.######.#..##.......#..#.....
.....#..#......##.#.#...#......
....#....#..#.....#.......#.#.#
.....#........##.....#.....#.##
........#....#...#...#.#.#...#.
...#.#.....#...........#.....#.
#.#.#...###......#.....#.....#.
.#..........#.....#.......##...
#................#.#.....#.####
.#......#......#.#..##.#.##....
..........#....#...........###.
.##....#..####..#####..........
##.......##............#.....#.
...#.....#...#....#.......#....
.#....##......#.#...#....#.....
....#............##..........#.
.#....#....#.....#.#...........
.............##.#.##...#.#.#...
..#............#.#..##.#....##.
#.....#...##..........#.#.#...#
......#............#..........#
..##..#.....#........#.##..#..#
#..#.#..##.#.....##.#..........
#..#...#.#..#......##.......##.
.##......#...........##.....#..
...#.....#.....#..#....#.......
.....#...............#........#
.......#.....##..#..##..#.#.#..
#.#.....#..#..........##...#...
#..#......#.................#.#
.##...#....#...#...#.......#...
.#........##........#..........
........#..........#.........#.
.....#.##..#.......#........#..
..##..#..#...##..#.#....#......
......#........#.##.....#.#....
.#...#.#.........#..#.#.#.#..#.
.#..#.#...#............#.#..#..
....#.................#...#..##
.........##.....#.#.#......####
...............#....##.#.#.....
....##..#....#......#....#.....
....##.#...#....#.#..#...#..#..
..##......#.#..#........#.#.#..
.........#.#................##.
##.....#.....##..##.#........#.
###....#..#..#..#..#.##..##.#..
.....##..#...........##..#.#...
....#..#..#..#....#...#.#....#.
#....#............#..#....###..
....#..#.............#....##.#.
...#.................#...#.....
.##...#....#..#..#........#....
...#.#..#...#.#......#....#....
...#.......##..........#...#.#.
...##..#.......#........#...#..
.....#.#.#....#..##......##...#
....##......#........##....##..
..#..........#.#.##.....#......
..................#..#..#..###.
.#..............#.#..#.#..#.###
..#....#....#......#..##..#...#
#.........#..#..#...........#..