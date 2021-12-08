# frozen_string_literal: true

data_array = File.readlines('data_file.txt')

# want to reject any output digits except those with length 2, 3, 4, 7
filtered_outputs = data_array.map{ |entry| entry.split(' | ')[1].strip.split.reject { |digit| ![2,3,4,7].include?(digit.length) } }

puts filtered_outputs.flatten.length

