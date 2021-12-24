# frozen_string_literal: true

require 'json'

number_array = File.readlines('data_file.txt').map(&:strip)

puts number_array.to_s

# string method
def must_explode?(string)
  index = 0
  count = 0
  while index < string.length
    count += 1 if string[index] == '['
    count -= 1 if string[index] == ']'
    index += 1
    return true if count > 4
  end
end

def numeric?(char)
  char.match?(/[[:digit:]]/)
end

def explode(string)
  raise ArgumentError unless must_explode?(string)
  # find first pair to explode
  count = 0
  index1 = 0
  while count < 5
    count += 1 if string[index1] == '['
    count -= 1 if string[index1] == ']'
    index1 += 1
  end

  # so we're at the beginning of our pair to explode
  pair = ''
  index2 = index1
  until string[index2] == ']'
    pair += string[index2]
    index2 += 1
  end
  left = pair.split(',')[0].to_i
  right = pair.split(',')[1].to_i

  # now need to work back from index1 to find previous number if it exists
  index3 = index1 - 1
  while index3 > 0 && !numeric?(string[index3])
    index3 -= 1
  end
  if index3 > 0 # we have a number, tho may be double digit
    string_number_left = string[index3]
    index4 = index3 - 1
    while numeric?(string[index4]) && index4 >= 0
      string_number_left = string[index4] + string_number_left
      index4 -= 1
    end
    final_string_number_left = string_number_left.to_i + left
  end

  # and forward from index 2 to find next number if it exists
  index5 = index2 + 1
  while index5 < string.length && !numeric?(string[index5])
    index5 += 1
  end
  if index5 < string.length # we have a number, tho may be double digit
    string_number_right = string[index5]
    index6 = index5 + 1
    while numeric?(string[index6]) && index6 >= 0
      string_number_right += string[index6]
      index6 += 1
    end
    final_string_number_right = string_number_right.to_i + right
  end
  # we can now put everything back together again:
  if index3 > 0
    left_final_string = string[0..index4] + final_string_number_left.to_s + string[index3 + 1..index1 - 2]
  else
    left_final_string = string[0..index1 - 2]
  end

  if index5 < string.length
    right_final_string = string[index2 + 1..index5 - 1] + final_string_number_right.to_s + string[index6..string.length]
  else
    right_final_string = string[index2 + 1..string.length]
  end

  return left_final_string + 0.to_s + right_final_string
end

def must_split?(string)
  index = 0
  count = 0
  while index < string.length
    numeric?(string[index]) ? count += 1 : count = 0
    index += 1
    return true if count >= 2
  end
end

def split(string)
  raise ArgumentError unless must_split?(string)
  index1 = 0
  count = 0
  while index1 < string.length && count < 2
    numeric?(string[index1]) ? count += 1 : count = 0
    index1 += 1
  end
  # so we're at the beginning of our number to split
  index2 = index1
  while index2 < string.length && numeric?(string[index2])
    index2 += 1
  end
  left_string = string[0..index1 - 3]
  right_string = string[index2..string.length]

  # now split our number
  num_to_split = string[index1 - 2.. index2].to_i

  # right hand of pair is rounded up if nec
  right = num_to_split % 2 == 0 ? num_to_split.div(2) : num_to_split.div(2) + 1
  left = num_to_split.div(2)

  return left_string + '[' + left.to_s + ',' + right.to_s + ']' + right_string
end



def process(sf)
  return sf.to_s unless must_explode?(sf) || must_split?(sf)

  # otherwise always explode if we can
  return process(explode(sf)) if must_explode?(sf)
  return process(split(sf)) if must_split?(sf)
end

def add(sf_1, sf_2)
  start = '[' + sf_1 + ',' + sf_2 + ']'
  process(start)
end

def magnitude(sf_array)
  return sf_array if sf_array.is_a?(Integer)

  # otherwise recursion
  return 3 * magnitude(sf_array[0]) + 2 * magnitude(sf_array[1])
end

# puts "magnitude = " + magnitude([[[[0,7],4],[[7,8],[6,0]]],[8,1]]).to_s
# puts add("[[[[4,3],4],4],[7,[[8,4],9]]]","[1,1]")


sum = number_array[0]

[*1..number_array.length - 1].each do |index|
  sum = add(sum, number_array[index])
end

puts magnitude(JSON.parse(sum))

###### part 2 ######

# brute force... use a hash...
totals = {}
number_array.each do |num_1|
  number_array.each do |num_2|
    if num_1 != num_2
      totals[[num_1, num_2]] = magnitude(JSON.parse(add(num_1, num_2)))
    end
  end
end

puts totals.to_s

puts totals.values.max
