# frozen_string_literal: true
# get array
data_array = File.readlines('data_file.txt')

len = data_array.length
# initialize our count
count_checks = 0
aim = 0
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

  # down X increases your aim by X units.
  # up X decreases your aim by X units.
  # forward X does two things:
  #   It increases your horizontal position by X units.
  #   It increases your depth by your aim multiplied by X.

  case cmd
  when 'forward'
    d += aim * value
    x += value
  when 'up'
    aim -= value
  when 'down'
    aim += value
  end

}
puts x, d, count_checks, x*d


