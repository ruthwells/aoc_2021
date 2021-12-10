# frozen_string_literal: true

# add edge row and column with height 10 so we can use same logic for edge and non-edge positions

heights = File.readlines('data_file.txt')
              .map { |entry| entry.strip.chars.map { |char| [char.to_i, 0] }.append([10, 0]) }.append(Array.new(101, [10, 0]))

# puts heights.to_s
[*0..99].each do |x|
  [*0..99].each do |y|
    if heights[x][y][0] == heights[x + 1][y][0]
      heights[x][y][1] = 1
      heights[x + 1][y][1] = 1
    elsif heights[x][y][0] > heights[x + 1][y][0]
      heights[x][y][1] = 1
    else
      heights[x + 1][y][1] = 1
    end

    if heights[x][y][0] == heights[x][y + 1][0]
      heights[x][y][1] = 1
      heights[x][y + 1][1] = 1
    elsif heights[x][y][0] > heights[x][y + 1][0]
      heights[x][y][1] = 1
    else
      heights[x][y + 1][1] = 1
    end
  end
end

sum_of_low_points = heights.map { |row| row.map { |pair| (pair[0] + 1) * (1 - pair[1]) }.sum }.sum
puts sum_of_low_points
