class Array
  def reverse_sublist!(pos, len)
    initial_pos = pos

    sublist = []
    while len > 0
      pos = 0 if pos == self.size
      sublist << self.slice(pos)
      pos += 1
      len -= 1
    end

    sublist.reverse!

    pos = initial_pos

    until sublist.empty?
      pos = 0 if pos == self.size
      self[pos] = sublist.shift
      pos += 1
    end

    self
  end
end

lengths = [106, 16, 254, 226, 55, 2, 1, 166, 177, 247, 93, 0, 255, 228, 60, 36]
list = (0..255).to_a

# lengths = [3, 4, 1, 5]
# list = [0, 1, 2, 3, 4]

pos = 0
skip = 0

until lengths.empty?
  # puts list.inspect
  len = lengths.shift
  list.reverse_sublist!(pos, len)
  pos = (pos + len + skip) % list.size
  skip += 1
end

puts list[0] * list[1]
