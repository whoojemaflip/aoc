gen_a = 618
gen_b = 814

gen_a_factor = 16807
gen_b_factor = 48271

divisor = 2147483647

bitmask = 65535

score = 0

def next_multiple(prev, factor, divisor, multiple)
  val = ((prev * factor) % divisor)

  if val % multiple == 0
    val
  else
    next_multiple(val, factor, divisor, multiple)
  end
end

5000000.times do 
  gen_a = next_multiple(gen_a, gen_a_factor, divisor, 4)
  gen_b = next_multiple(gen_b, gen_b_factor, divisor, 8)

  if bitmask & gen_a == bitmask & gen_b
    score += 1
  end 
end

puts score
