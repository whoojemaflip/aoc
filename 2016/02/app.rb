require_relative 'keypad_two'

data = File.open("./doorcode.txt", 'rb').read
kb = KeypadTwo.new
out = kb.door_code(data)
puts out.join
