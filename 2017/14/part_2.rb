require_relative 'knot_hash'

input = "ffayrhll"
example = "flqrgnkx"

test_hex = "a0c2017"
test_bin = "1010000011000010000000010111"

def assert_equal(a, b)
  raise unless a == b
end

assert_equal test_hex.to_bin_string, test_bin

disk = (0..127).map do |i|
  "#{input}-#{i}".to_knot_hash.to_bin_string.each_char.to_a
end

def reset_adjacent(disk, x, y)
  if disk[y][x] == "1"
    disk[y][x] = "0"
    reset_adjacent(disk, x - 1, y) if x > 0
    reset_adjacent(disk, x + 1, y) if x < 127
    reset_adjacent(disk, x, y - 1) if y > 0
    reset_adjacent(disk, x, y + 1) if y < 127
    1
  else
    0
  end
end

region_count = 0

(0..127).each do |x|
  (0..127).each do |y|
    region_count += reset_adjacent(disk, x, y)
  end
end

puts region_count
