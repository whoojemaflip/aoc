require_relative 'passphrase'
require 'rspec'

RSpec.describe Passphrase do
  example 'Part 1' do
    expect(Passphrase.part_1_valid?("aa bb cc dd ee")).to be true
    expect(Passphrase.part_1_valid?("aa bb cc dd aa")).to be false
    expect(Passphrase.part_1_valid?("aa bb cc dd aaa")).to be true
  end

  example 'Part 2' do
    expect(Passphrase.part_2_valid?("abcde fghij")).to be true
    expect(Passphrase.part_2_valid?("abcde xyz ecdab")).to be false
    expect(Passphrase.part_2_valid?("a ab abc abd abf abj")).to be true
    expect(Passphrase.part_2_valid?("iiii oiii ooii oooi oooo")).to be true
    expect(Passphrase.part_2_valid?("oiii ioii iioi iiio ")).to be false
  end
end
