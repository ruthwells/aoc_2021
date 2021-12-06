# frozen_string_literal: true
# get array
data_array = File.readlines('data_file.txt')

len = data_array.length
# initialize our count
count_checks = 0
x = 0
d = 0

data_array.each { |entry|
  puts entry
  count_checks += 1
  # split on space
  cmd = entry.split[0]
  puts cmd
  value = entry.split[1].to_i
  puts value
  case cmd
  when 'forward'
    x += value
  when 'up'
    d -= value
  when 'down'
    d += value
  end

}
puts x, d, count_checks, x*d


