require 'pry'

input = File.read("input.txt")

# input = <<EOF
#      |          
#      |  +--+    
#      A  |  C    
#  F---|----E|--+ 
#      |  |  |  D 
#      +B-+  +--+ 
# EOF

maze = input.split("\n").map { |l| l.split(//) }


def char_at(pos, maze)
  x = pos[:x]
  y = pos[:y]

  maze[y][x]
end

def next_pos(pos, dir, maze)
  case dir
  when :up
    { x: pos[:x], y: pos[:y] - 1 }
  when :down
    { x: pos[:x], y: pos[:y] + 1 }
  when :left
    { x: pos[:x] - 1, y: pos[:y] }
  when :right
    { x: pos[:x] + 1, y: pos[:y] }
  else
    binding.pry
  end
end

def valid_pos?(pos, maze)
  pos[:x] >= 0 && 
    pos[:x] < maze[0].size &&
    pos[:y] >= 0 &&
    pos[:y] < maze.size
end

def inverse_dir(dir)
  case dir
  when :up
    :down
  when :down
    :up
  when :left
    :right
  when :right
    :left
  end
end

def next_char(pos, dir, maze)
  char_at(next_pos(pos, dir, maze), maze)
end

def prev_char(pos, dir, maze)
  next_char(pos, inverse_dir(dir), maze)
end

def possible_directions(dir)
  [:up, :down, :left, :right] - [dir] - [inverse_dir(dir)]
end

def next_dir(pos, dir, maze)
  case char_at(pos, maze)
  when "+"
    dirs = possible_directions(dir).reject do |new_dir| 
      if valid_pos?(next_pos(pos, new_dir, maze), maze)
        nc = next_char(pos, new_dir, maze)
        pc = prev_char(pos, dir, maze)
        nc == pc || nc == ' '
      else
        true
      end
    end
    binding.pry if dirs.size > 1
    dirs[0]
  else
    dir
  end
end

start_pos = maze[0].index("|")
pos = {x: start_pos, y: 0}
dir = :down
path = ""
steps = 1

while true
  steps += 1
  pos = next_pos(pos, dir, maze)
  break unless valid_pos?(pos, maze)

  if /[A-Z]/.match char_at(pos, maze)
    path += char_at(pos, maze)
  end

  break if char_at(pos, maze) == 'U'
  dir = next_dir(pos, dir, maze)
end

puts path
puts steps
