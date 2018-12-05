require 'matrix'

class Particle
  def initialize(str, i)
    regex = %r{^p=<(.+?)>, v=<(.+?)>, a=<(.+?)>$}
    matches = regex.match str

    @position = to_vec matches[1]
    @velocity = to_vec matches[2]
    @acceleration = to_vec matches[3]

    @index = i
  end

  def index
    @index
  end

  def to_vec(str)
    Vector.elements str.split(',').map(&:to_i)
  end

  def manhattan_distance
    @position.to_a.map(&:abs).inject(&:+)
  end

  def abs_acceleration
    @acceleration.to_a.map(&:abs).inject(&:+)
  end

  def abs_velocity
    @velocity.to_a.map(&:abs).inject(&:+)
  end
end  

particles = File.read('input.txt').split("\n").each_with_index.map { |line, index| Particle.new(line, index) }

min_acceleration = particles.map(&:abs_acceleration).min
particles.reject! { |p| p.abs_acceleration > min_acceleration }

min_velocity = particles.map(&:abs_velocity).min
particles.reject! { |p| p.abs_velocity > min_velocity }

min_distance = particles.map(&:manhattan_distance).min
particles.reject! { |p| p.manhattan_distance > min_distance }

puts particles[0].index.to_s
