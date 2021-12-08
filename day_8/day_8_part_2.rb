# frozen_string_literal: true

data = File.readlines('data_file.txt').map { |entry| entry.split(' | ') }
grand_total = 0

data.each do |entry|
  map = {}
  inputs = entry[0].split.map! { |word| word.chars.sort }

  inputs.each do |code|
    case code.length
      # anything encoded as 7 chars must be 8
    when 7
      map[8] = code
      # anything encoded as 2 chars must be 1
    when 2
      map[1] = code
      # anything encoded as 3 chars must be 7
    when 3
      map[7] = code
      # anything encoded as 4 chars must be 4
    when 4
      map[4] = code
      # anything encoded as 6 chars must be 6
    end
  end

  # second pass for the non-obvious ones
  inputs.reject { |x| [map[1], map[8], map[4], map[7]].include?(x) }.each do |code|
    # look at size of intersection with known encodings from 1st pass
    # if it gives a 4 when intersected with 4, must be a 9
    if map[4] & code == map[4]
      map[9] = code
    # if it gives an 8 when combined with a 7, must be a 6
    elsif (map[7] | code).sort == map[8]
      map[6] = code
    # if it gives an 8 when combined with a 4, it's either a 0 or a 2,
    # but a 2 won't give a 7 when intersected with a 7
    elsif (map[4] | code).sort == map[8]
      map[7] & code == map[7] ? map[0] = code : map[2] = code
    # if it gives a 7 when intersected with 7, must be a 3
    elsif map[7] & code == map[7]
      map[3] = code
    else # we've exhausted all other options...
      map[5] = code
    end
  end

  # now we can finally decode the output and sum
  power = entry[1].split.length - 1
  entry[1].split.map! { |word| word.chars.sort }.each do |code|
    number = 0
    number += map.key(code) * (10 ** power)
    power -= 1
    grand_total += number
  end
end
puts grand_total



