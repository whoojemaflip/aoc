gen_a = 618
gen_b = 814

gen_a_factor = 16807
gen_b_factor = 48271

divisor = 2147483647

bitmask = 65535

score = 0

40000000.times do 
  gen_a = (gen_a * gen_a_factor) % divisor
  gen_b = (gen_b * gen_b_factor) % divisor

  if bitmask & gen_a == bitmask & gen_b
    score += 1
  end 
end

puts score
