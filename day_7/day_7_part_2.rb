# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
positions = data_array[0].split(',').map { |num| num.to_i}

def fuel2(positions, x)
  # recall nth triangle number = n(n+1)/2
  positions.map { |pos| ((pos - x).abs * ((pos - x).abs + 1)) / 2 }.sum
end

min_fuel2 = [*positions.min..positions.max].map { |x| fuel2(positions, x) }.min

puts min_fuel2.to_s
