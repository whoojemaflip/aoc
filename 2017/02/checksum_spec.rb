require_relative 'checksum'
require 'rspec'

RSpec.describe Checksum do
  example 'Part 1' do
    input = <<-EOS
5 1 9 5
7 5 3
2 4 6 8
    EOS
    
    result = Checksum.part_1(input)
    expect(result).to eql 18
  end

  example 'Part 2' do
    input = <<-EOS
5 9 2 8
9 4 7 3
3 8 6 5
    EOS

    result = Checksum.part_2(input)
    expect(result).to eql 9
  end
end
