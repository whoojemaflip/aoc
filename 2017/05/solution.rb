require_relative 'cpu'

input = File.read('input.txt').strip.split("\n").map(&:to_i)
# cpu = Cpu.new(input, 0)
# puts cpu.run_1

cpu = Cpu.new(input, 0)
puts cpu.run_2
