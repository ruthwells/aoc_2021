# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
fish = data_array[0].split(',').map { |num| num.to_i}

def total(fish_array, num_days)
  return fish_array.length if num_days.zero?
  # or call fn recursively
  total(fish_array.map! do |timer|
    timer.zero? ? [6, 8] : timer -= 1
  end.flatten, num_days - 1)
end

puts total(fish, 80)