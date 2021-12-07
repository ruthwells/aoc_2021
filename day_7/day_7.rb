# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
positions = data_array[0].split(',').map { |num| num.to_i}

def fuel(positions, x)
  positions.map { |pos| (pos - x).abs }.sum
end

min_fuel = [*positions.min..positions.max].map { |x| fuel(positions, x) }.min

puts min_fuel.to_s
