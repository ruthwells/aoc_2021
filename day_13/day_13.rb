# frozen_string_literal: true

data_array = File.readlines('data_file.txt')

grid = []
fold_lines = []

data_array.each do |entry|
  if entry.include?('fold')
    fold_lines << entry.strip.split[2].split('=').map { |el| el.to_i.to_s == el ? el.to_i : el }
  else
    grid << entry.strip.split(',').map(&:to_i) unless entry.strip.empty?
  end
end

def fold(grid, fold_line)
  grid.dup.each_with_index do |point, index|
    grid[index][0] = 2 * fold_line[1] - grid[index][0] if fold_line[0] == 'x' && grid[index][0] > fold_line[1]
    grid[index][1] = 2 * fold_line[1] - grid[index][1] if fold_line[0] == 'y' && grid[index][1] > fold_line[1]
  end.uniq
end

puts fold(grid, fold_lines[0]).length