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

low_points = []
[*0..99].each do |row|
  [*0..99].each do |col|
    if heights[row][col][1] == 0
      low_points << [row, col]
    end
  end
end

# use a recursive function
# input is grid of positions, and a row/col combination

heights2 = File.readlines('data_file.txt').map { |entry| entry.strip.chars.map(&:to_i) }

def basin(heights, row, col, visited)
  return 0 if heights[row, col] == 9 || visited.include?([row, col])

  # otherwise we have a legitimate part of a basin
  basin_size = 1
  visited << [row, col]

  if row > 0 && heights[row - 1][col] !=9 && heights[row - 1][col] > heights[row][col]
    basin_size += basin(heights, row - 1, col, visited)
  end

  if row < 99 && heights[row + 1][col] !=9 && heights[row + 1][col] > heights[row][col]
    basin_size += basin(heights, row + 1, col, visited)
  end

  if col > 0 && heights[row][col - 1] !=9 && heights[row][col - 1] > heights[row][col]
    basin_size += basin(heights, row, col - 1, visited)
  end

  if col < 99 && heights[row][col + 1] !=9 && heights[row][col + 1] > heights[row][col]
    basin_size += basin(heights, row, col + 1, visited)
  end

  return basin_size
end

basin_sizes = []
low_points.each do |point|
  basin_sizes << basin(heights2, point[0], point[1], [])
end

basin_sizes.sort!.to_s

puts basin_sizes[-1] * basin_sizes[-2] * basin_sizes[-3]
