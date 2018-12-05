banks = [11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]
#banks = [0, 2, 7, 0]
states = {}
counter = 0

class Array
  def to_key
    self.join(',')
  end
end

while(!states.include?(banks.to_key)) do
  states[banks.to_key] = counter

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

looper = counter - states[banks.to_key]
puts looper
