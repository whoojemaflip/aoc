require_relative 'checksum'

input = File.read('input.txt').strip

puts Checksum.part_1(input)
puts Checksum.part_2(input)
