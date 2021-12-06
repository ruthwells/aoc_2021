# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
# split the data into bingo numbers and boards

coordinates = data_array.map { |row| row.to_s.strip.split(' -> ') }.each { |pair| pair.map! { |string| string.split(',').map { |num| num.to_i}}}

# first find the size of our grid [min_x, max_x, min_y, max_y]
bounds = coordinates.each_with_object([0, 0, 0, 0]) do |line, array|
  array[0] = [array[0], line[0][0], line[1][0]].min
  array[1] = [array[1], line[0][0], line[1][0]].max
  array[2] = [array[2], line[0][1], line[1][1]].min
  array[3] = [array[3], line[0][1], line[1][1]].max
end

# now get our grid, with ability to count
grid = {}
for x in bounds[0]..bounds[1]
  for y in bounds[2]..bounds[3]
    grid[[x, y]] = 0
  end
end

puts grid.length

# now retain only the horizontal and vertical lines
simple_lines = []
coordinates.each do |pair|
  simple_lines << pair if pair[0][0] == pair[1][0] || pair[0][1] == pair[1][1]
end

# now do the work

simple_lines.each do |pair|
  if pair[0][0] == pair[1][0] # we have a vertical line so look at min & max y
    for y in [pair[0][1], pair[1][1]].min..[pair[0][1], pair[1][1]].max
      grid[[pair[0][0],y]] += 1
    end
  elsif pair[0][1] == pair[1][1] # we have a horizontal line so look at min & max x
    for x in [pair[0][0], pair[1][0]].min..[pair[0][0], pair[1][0]].max
      grid[[x, pair[1][1]]] += 1
    end
  end
end

# get what we're after
num_danger_spots = 0
grid.each do |pos, count|
  num_danger_spots += 1 if count >= 2
end

puts grid.to_s
puts simple_lines.to_s
puts num_danger_spots




