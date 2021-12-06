# frozen_string_literal: true
# get array

start_array = File.readlines('data_file.txt')

# use a recursive solution
def filter(data_array, pos, criterion)
  # return if we are down to a single entry
  if data_array.length == 1
    return data_array
  end

  # otherwise we have work to do so reinitialize our counters...
  ones_array = []
  zeros_array = []
  ones_check = 0
  zeros_check = 0

  data_array.each { |entry|
    case entry[pos].to_i
    when 1
      ones_array.append(entry)
      ones_check += 1
    when 0
      zeros_array.append(entry)
      zeros_check += 1
    end
  }

  if criterion == 'o2'
    if ones_check >= zeros_check
      filter(ones_array, pos + 1, 'o2')
    else
      filter(zeros_array, pos + 1, 'o2')
    end
  else # co2
    if ones_check < zeros_check
      filter(ones_array, pos + 1, 'co2')
    else
      filter(zeros_array, pos + 1, 'co2')
    end
  end
end

def bin_to_dec(binary)
  binary.reverse.chars.map.with_index do |digit, index|
    digit.to_i * 2**index
  end.sum
end
puts bin_to_dec(filter(start_array, 0, 'co2')[0].strip) * bin_to_dec(filter(start_array, 0, 'o2')[0].strip)

