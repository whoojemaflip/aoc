require_relative 'knot_hash'

input = "ffayrhll"

test_hex = "a0c2017"
test_bin = "1010000011000010000000010111"

def assert_equal(a, b)
  raise unless a == b
end

assert_equal test_hex.to_bin_string, test_bin

hashes = (0..127).map do |i|
  "#{input}-#{i}".to_knot_hash.to_bin_string.each_char.to_a.sum
end

puts hashes.sum
