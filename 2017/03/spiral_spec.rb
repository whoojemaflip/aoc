require_relative 'spiral'
require 'rspec'

RSpec.describe Spiral do
  example 'Part 1' do
    expect(Spiral.part_1(1)).to eql 0
    expect(Spiral.part_1(12)).to eql 3
    expect(Spiral.part_1(23)).to eql 2
    expect(Spiral.part_1(1024)).to eql 31
  end

  example 'Part 2' do
    expect(Spiral.part_2(1)).to eql 2
    expect(Spiral.part_2(2)).to eql 4
    expect(Spiral.part_2(5)).to eql 10
    expect(Spiral.part_2(15)).to eql 23
    expect(Spiral.part_2(100)).to eql 122
  end
end
