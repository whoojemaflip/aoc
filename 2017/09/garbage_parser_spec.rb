require_relative 'garbage_parser'
require 'rspec'

RSpec.describe GarbageParser do
  def subject(input)
    GarbageParser.new(input)
  end

  example "part1" do
    expect(subject("{}").score).to eql 1
    expect(subject("{{{}}}").score).to eql 6
    expect(subject("{{},{}}").score).to eql 5
    expect(subject("{{{},{},{{}}}}").score).to eql 16
    expect(subject("{<a>,<a>,<a>,<a>}").score).to eql 1
    expect(subject("{{<ab>},{<ab>},{<ab>},{<ab>}}").score).to eql 9
    expect(subject("{{<!!>},{<!!>},{<!!>},{<!!>}}").score).to eql 9
    expect(subject("{{<a!>},{<a!>},{<a!>},{<ab>}}").score).to eql 3
  end

  example "part2" do
    expect(subject("<>").garbage_chars).to eql 0
    expect(subject("<random characters>").garbage_chars).to eql 17
    expect(subject("<<<<>").garbage_chars).to eql 3
    expect(subject("<{!>}>").garbage_chars).to eql 2
    expect(subject("<!!>").garbage_chars).to eql 0
    expect(subject("<!!!>>").garbage_chars).to eql 0
    expect(subject('<{o"i!a,<{i<a>').garbage_chars).to eql 10
  end
end 
