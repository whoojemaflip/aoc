require 'set'

input = DATA.each_line.map do |ln| 
  coords = ln.split(/[^\d]+?/)
  coords.reject(&:empty?).map(&:to_i)
end

min_x = input.min_by { |x,y| x }.first
max_x = input.max_by { |x,y| x }.first - min_x
min_y = input.min_by { |x,y| y }.last
max_y = input.max_by { |x,y| y }.last - min_y

input2 = input.map { |x,y| [x - min_x, y - min_y] }

# puts max_x # 308
# puts max_y # 310
# 90,000 grid coords

GRID = Array.new(max_x + 1) { Array.new(max_y + 1) }

# mark each grid location with the nearest coordinate
# by cycling through the coordinates, and comparing their distance
# to the current coordinate. If it is the current nearest mark it as such
# or if it the same distance, then tag it as belonging to coordinate -1

closest = Proc.new do |x,y|
  best = GRID[x][y].min_by { |k,v| v }.last
  GRID[x][y].select { |k,v| v == best }.keys
end

plot_grid = Proc.new do
  (0..max_y).each do |y|
    row = []
    (0..max_x).each do |x|
     # puts GRID[x][y]
      c = closest.(x,y)
      if c.size > 1
        chr = '.'
      else
        chr = (c.first + 65).chr
      end
      row << chr
    end
    puts row.join
  end
end

input2.each.with_index do |(x,y), index|
  (0..max_x).each do |grid_x|
    (0..max_y).each do |grid_y|
      GRID[grid_x][grid_y] ||= {}
      GRID[grid_x][grid_y][index] = (x-grid_x).abs + (y-grid_y).abs
    end
  end
end

#plot_grid.call

# now we flag all the infinite areas
# defined as those that touch an edge

infinite_areas = Set.new
(0..max_x).each { |x| infinite_areas.add closest.(x, 0); infinite_areas.add closest.(x, max_y) }
(0..max_y).each { |y| infinite_areas.add closest.(0, y); infinite_areas.add closest.(max_x, y) }

finite_areas = (infinite_areas ^ Set.new(0..input.size - 1)).to_a
results = {}

# now lets count the number of areas tagged to each _finite_ coordinate
GRID.map do |g1| 
  g1
    .group_by { |loc| loc[:index] }
    .delete_if { |k,v| infinite_areas.include?(k) }
    .reduce({}) { |memo, (k,v)| memo[k] = v.size; memo }
end.each do |grouped_hash|
  grouped_hash.each do |k,v| 
    results[k] ||= 0
    results[k] += v
  end
end

puts results.max_by { |k,v| v }.last

part_2_total = 0
max_distance = 10000
GRID.each do |g1|
  g1.each do |coord_hash|
    sum = coord_hash.reduce(0) { |memo, (coord, distance)| memo + distance }
    part_2_total += 1 if sum < max_distance
  end
end

puts part_2_total

__END__
63, 142
190, 296
132, 194
135, 197
327, 292
144, 174
103, 173
141, 317
265, 58
344, 50
184, 238
119, 61
329, 106
70, 242
272, 346
312, 166
283, 351
286, 206
57, 225
347, 125
152, 186
131, 162
45, 299
142, 102
61, 100
111, 218
73, 266
350, 173
306, 221
42, 284
150, 122
322, 286
346, 273
75, 354
68, 124
194, 52
92, 44
77, 98
77, 107
141, 283
87, 306
184, 110
318, 343
330, 196
303, 353
268, 245
180, 220
342, 337
127, 107
203, 127