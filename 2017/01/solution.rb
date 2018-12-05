require_relative 'captcha'

input = File.read('input.txt').strip

puts "Part 1"
result = Captcha.new(input).part_1
puts result
puts
puts "Part 2"
result = Captcha.new(input).part_2
puts result
