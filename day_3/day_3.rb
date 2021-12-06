# frozen_string_literal: true
# get array
data_array = File.readlines('data_file.txt')

len = data_array.length
# initialize our count
count_checks = 0
digits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

data_array.each { |entry|
  puts entry
  count_checks += 1
  for i in 0..11
    puts entry[i]
    puts digits[i]
    puts "_____"
    digits[i] += entry[i].to_i
  end

}
puts digits, count_checks

gamma = 0
epsilon = 0


for i in 0..11
  digits[i] > 500 ? gamma += 2**(11-i) : epsilon += 2**(11-i)
end

puts gamma, epsilon, gamma * epsilon