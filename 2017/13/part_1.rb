input = File.read('input.txt').strip.split("\n")

max_layers = input.last.split(": ")[0].to_i
layers = Array.new(max_layers, nil)

input.reduce(layers) do |acc, line|
  dr = line.split(": ").map(&:to_i)
  acc.tap { acc[dr[0]] = dr[1] }
end

score = 0

def scanner_in_home_position?(time, range)
  return false unless range
  cadence = (range - 1) * 2
  time % cadence == 0
end

layers.each_with_index do |range, depth|
  if scanner_in_home_position?(depth, range)
    score += (range * depth)
  end
end

puts score
