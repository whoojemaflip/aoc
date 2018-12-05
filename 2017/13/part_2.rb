input = File.read('input.txt').strip.split("\n")
max_layers = input.last.split(": ")[0].to_i
layers = Array.new(max_layers, nil)

input.reduce(layers) do |acc, line|
  dr = line.split(": ").map(&:to_i)
  acc.tap { acc[dr[0]] = dr[1] }
end

def scanner_in_home_position?(time, range)
  return false unless range
  cadence = (range - 1) * 2
  time % cadence == 0
end

def viable?(delay, layers)
  layers.each_with_index do |range, depth|
    return false if scanner_in_home_position?(depth + delay, range)
  end
  true
end

i = 0
while true
  if viable?(i, layers)
    break
  else
    i += 1
  end
end

puts i
