require 'set'

banks = [11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]
#banks = [0, 2, 7, 0]
states = Set.new()
counter = 0

while(!states.include?(banks.join(','))) do
  states.add(banks.join(','))

  i = banks.find_index(banks.max)
  redist = banks[i]
  banks[i] = 0

  while(redist > 0) do
    i += 1
    i = 0 if i == banks.length
    banks[i] += 1
    redist -= 1
  end

  counter += 1
end

puts counter
