# frozen_string_literal: true

require 'json'

data_array = File.readlines('data_file.txt')
data_array.map! do |line|
  line.to_s.strip
end

data_array.each do |line|
  puts line.length
end

algo = data_array[0].strip

image_width = data_array[2].strip.length
image_height = data_array.length - 2

image = Array.new(image_height + 240) { Array.new(image_width + 240) }
[*0..119].each do |i|
  image[i] = ("." * (image_width + 240)).chars
end
[*120..image_height + 119].each do |i|
  image[i] = ("." * 120 + data_array[i - 118].strip + "." * 120).chars
end
[*image_height + 120..image_height + 239].each do |i|
  image[i] = ("." * (image_width + 240)).chars
end

[*0..image.length + 240].each do |i|
  puts image[i].to_s
end

def bin_to_dec(string)
  # puts string
  puts "oops" if string.length < 9
  string.chars.reverse.map.with_index do |digit, index|
    digit.to_i * 2**index
  end.sum
end

# define our binary_number for all elements of the padded image
def dec_number(image, pos) # i and j >=1 and i, j < 119
  # puts "pos = " + pos.to_s
  bin_to_dec((image[(pos[0] - 1)][(pos[1] - 1)..(pos[1] + 1)] +
    image[pos[0]][(pos[1] - 1)..(pos[1] + 1)] +
    image[pos[0] + 1][(pos[1] - 1)..(pos[1] + 1)]).map { |el| el == '#' ? '1' : '0' }.join)
end

def enhance_image(image, algo, result, size)

  [*1..(size-1)].each do |i|
    #puts "i = " + i.to_s
    new_row = []
    [*1..size-1].each do |j|
      # puts image.length
      #  puts image[0].length
      #puts "size = " + size.to_s + ", i = " + i.to_s + ", j = " + j.to_s
      dec_number = dec_number(image, [i,j])
      #puts dec_number
      # puts "check is new_row an array? " + (new_row.is_a?(Array)).to_s
      # puts "check is new_row an string? " + (image[i].is_a?(String)).to_s
      #puts algo[dec_number]
      new_row << algo[dec_number]
      #puts new_row.to_s
    end
    result[i] = new_row
  end
end

results = Array.new(4)

results[1] = Array.new(339) {Array.new(339)}
enhance_image(image, algo, results[1], 339)

[*2..50].each do |n|
  puts "n = " + n.to_s
  results[n] = Array.new(340 - 1 * n) { Array.new(340 - 1 * n) }
  enhance_image(results[n-1], algo, results[n], 340 - 1 * n - 1)

  puts "length = " + results[n].length.to_s
  [*0..results[n].length - 1].each do |i|
    puts results[n][i].join.to_s
  end
end

# need to get rid of crud at the top and to the right
results[50].shift(50)

[*0..results[50].length - 1].each do |i|
  puts results[50][i].join.to_s
end

results[50].each do |row|
  row.pop(50)
end

[*0..results[50].length - 1].each do |i|
  puts results[50][i].join.to_s
end

results[50].each do |row|
  row.reject! { |el| el != '#' }
end

puts "============"
results[50].each do |row|
  puts row.to_s
end
puts "============"
result = results[50].flatten.length
puts result
puts "============"
