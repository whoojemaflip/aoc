final = <<eof
R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1
eof

test_1 = "R2, L3" # 5
test_2 = "R2, R2, R2" # 2
test_3 = "R5, L5, R5, R3" # 12
test_4 = "R8, R4, R4, R8"


input = final.split(', ')

def move(cardinal, distance, n, w)
  case cardinal
  when 'N'
    n += distance
  when 'S'
    n -= distance
  when 'W'
    w += distance
  when 'E'
    w -= distance
  end
  return n, w
end

def parse_step(str)
  turn = str[0]
  distance = str[1..-1]
  return turn, Integer(distance)
end

@compass = %w[N W S E] * (input.length)
@compass_position = @compass.length / 2

n = 0
w = 0

move_history = []

input.each do |dir|
  turn, distance = parse_step(dir)
  if turn == 'L'
    @compass_position -= 1
  else
    @compass_position += 1
  end

  (1..distance).each do |i|
    n, w = move(@compass[@compass_position], 1, n, w)
    move_history << { n: n, w: w }
  end
end

distance = n.abs + w.abs

puts distance

twice_visited_locations = []

move_history.each_with_index do |pos, i|
  #puts pos.inspect
  next if i < 1
  (0..i-1).each do |j|
    if move_history[j][:n] == pos[:n] &&
      move_history[j][:w] == pos[:w]
      twice_visited_locations << pos
      break
    end
  end
end

if twice_visited_locations.size > 0
  puts twice_visited_locations[0][:n].abs + twice_visited_locations[0][:w].abs
else
  puts "No twice visited locations"
end
