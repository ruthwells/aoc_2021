# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
levels = data_array.map{ |entry| entry.strip.chars.map { |char| [char.to_i, false] } }

flashed = []

def adjacent_entries(x,y)
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1], [x - 1, y - 1], [x - 1, y + 1],
   [x + 1, y - 1], [x + 1, y + 1]] & [*0..9].product([*0..9])

end

def process(levels, x, y, flashed)
  if levels[x][y][0] <= 9 || levels[x][y][1]
    return # nothing to do
  else
    flashed << [x, y]
    levels[x][y][1] = true
    adjacent_entries(x, y).each do |coord|
      levels[coord[0]][coord[1]][0] += 1
      process(levels, coord[0], coord[1], flashed)
    end
  end
end

def process_flashes(levels)
  count = 0
  simultaneous = false

  until simultaneous do
    # reset set of flashed octopuses
    step_flashed = []
    # Step 1: increment and reset flashes to false for start of new step
    levels.each do |row|
      row.each do |entry|
        entry[0] += 1
        entry[1] = false
      end
    end
    # step 2
    [*0..9].each { |x| [*0..9].each { |y| process(levels, x, y, step_flashed) } }
    simultaneous = true if step_flashed.length == 100
    # step 3
    levels.each { |row| row.each { |entry| entry[0] = 0 if entry[0] > 9 } }
    count += 1
  end
  count
end


puts process_flashes(levels)
