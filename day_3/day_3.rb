# frozen_string_literal: true
data_array = File.readlines('data_file.txt')

count_checks = 0
digits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

data_array.each do |entry|
  count_checks += 1
  (0..11).each { |i| digits[i] += entry[i].to_i }
end

gamma = 0
epsilon = 0

(0..11).each do |i|
  digits[i] > 500 ? gamma += 2**(11-i) : epsilon += 2**(11-i)
end

puts gamma * epsilon
