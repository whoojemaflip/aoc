require 'matrix'

class Particle
  def initialize(str, i)
    regex = %r{^p=<(.+?)>, v=<(.+?)>, a=<(.+?)>$}
    matches = regex.match str

    @position = to_vec matches[1]
    @velocity = to_vec matches[2]
    @acceleration = to_vec matches[3]

    @collided = false
  end

  def index
    @index
  end

  def to_vec(str)
    Vector.elements str.split(',').map(&:to_i)
  end

  def tick
    @velocity += @acceleration
    @position += @velocity
  end

  def position
    @position.to_a.join(",")
  end

  def has_collided
    @collided = true
  end

  def collided?
    @collided
  end
end  

particles = File.read('input.txt').split("\n").each_with_index.map { |line, index| Particle.new(line, index) }

1000000  .times do
  positions = []

  particles.each do |p|
    if positions.include? p.position
      p.has_collided
    end

    positions << p.position
  end

  particles.reject! { |p| p.collided? }

  particles.map(&:tick)
end

puts particles.size
