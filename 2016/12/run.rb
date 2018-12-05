require_relative 'cpu'
require 'pry'

cpu = Cpu.new

cpu.load("./data.txt")
cpu.run
