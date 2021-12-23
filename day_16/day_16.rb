# frozen_string_literal: true

hex_string = File.readlines('data_file.txt')[0].strip.chars

puts hex_string.to_s

conversion_hash = { '0' => '0000', '1' => '0001', '2' => '0010', '3' => '0011', '4' => '0100', '5' => '0101',
                    '6' => '0110', '7' => '0111', '8' => '1000', '9' => '1001', 'A' => '1010', 'B' => '1011',
                    'C' => '1100', 'D' => '1101', 'E' => '1110', 'F' => '1111' }

bit_array = hex_string.map { |hex| conversion_hash[hex].scan /\w/ }.flatten.map(&:to_i)
puts bit_array.to_s

def bin_to_dec(array)
  array.reverse.map.with_index do |digit, index|
    digit.to_i * 2**index
  end.sum
end

version_total = []
def process_bit_array(bit_array, version_total)
  return if bit_array.max == 0 || bit_array.length == 0

  version = bin_to_dec(bit_array.shift(3))
  packet_type = bin_to_dec(bit_array.shift(3))
  case packet_type
  when 4
    # literal value to be read in and decoded
    version_total << version
    value_part = bit_array.shift(5)
    value_prefix = value_part.shift
    result = value_part
    while value_prefix != 0 && bit_array.length > 4
      value_part = bit_array.shift(5)
      value_prefix = value_part.shift
      result += value_part
    end
    value = bin_to_dec(result)
  else
    # operator packet
    length_type_id = bit_array.shift
    version_total << version
    if length_type_id.zero?
      total_length = bin_to_dec(bit_array.shift(15))
      sub_packets = bit_array.shift(total_length)
      while sub_packets.length > 0
        process_bit_array(sub_packets, version_total)
      end
    else # 1
      num_sub_packets = bin_to_dec(bit_array.shift(11))
      (1..num_sub_packets).each do |n|
        process_bit_array(bit_array, version_total)
      end
    end
  end
end

puts process_bit_array(bit_array, version_total).to_s
puts version_total.sum









