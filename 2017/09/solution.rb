require_relative 'garbage_parser'

input = File.read('input.txt').strip

parser = GarbageParser.new(input)

puts 'part 1'
puts parser.score
puts
puts 'part2'
puts parser.garbage_chars
