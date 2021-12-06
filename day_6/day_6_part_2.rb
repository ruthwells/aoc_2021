# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
fish = data_array[0].split(',').map { |num| num.to_i}

def num_after(array, num_days)
  # populate an array with no on subsequent days starting from one fish on day 0 with timer = 0
  # to get the no starting from one fish on day 0 with timer = t, we can simply shift back by t
  after = [1, 2, 2, 2, 2, 2, 2, 2, 3]
  (9..num_days).each { |n| after[n] = after[n - 7] + after[n - 9] }

  # then summarise our starting array and multiply by freqs after num_days
  [*0..8].map { |timer| array.count(timer) * after[num_days - timer] }.sum
end

puts num_after(fish, 256)