require_relative 'passphrase'

input = File.read('input.txt').strip

puts input.split("\n").keep_if { |phrase| Passphrase.part_1_valid?(phrase) }.count

puts input.split("\n").keep_if { |phrase| Passphrase.part_2_valid?(phrase) }.count
