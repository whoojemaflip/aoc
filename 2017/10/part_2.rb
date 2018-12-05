class Array
  def reverse_sublist!(pos, len)
    initial_pos = pos

    sublist = []
    while len > 0
      pos = 0 if pos == self.size
      sublist << self[pos]
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

  def xor
    eval(self.join(" ^ ")) #lol #h4xxor
  end

  def to_hex_string
    self.map { |a| "%02x" % a }.join
  end
end

class String
  def to_knot_hash
    lengths_suffix = [17, 31, 73, 47, 23]
    lengths = self.chars.map(&:ord) + lengths_suffix

    list = (0..255).to_a

    pos = 0
    skip = 0

    64.times do 
      round_lengths = lengths.dup

      until round_lengths.empty?
        len = round_lengths.shift
        list.reverse_sublist!(pos, len)
        pos = (pos + len + skip) % list.size
        skip += 1
      end
    end

    list.each_slice(16).map(&:xor).to_hex_string
  end
end

puts "106,16,254,226,55,2,1,166,177,247,93,0,255,228,60,36".to_knot_hash

