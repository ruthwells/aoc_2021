# frozen_string_literal: true

require 'json'

positions_array = File.readlines('data_file.txt').map(&:strip)

positions = {}
def parse_positions_array(array, positions)
  index = 0
  [*0..34].each do |s|
    positions[s] = []
    while index < array.length && array[index] != '--- scanner ' + s.to_s + ' ---'
      index += 1
    end
    index += 1 # want to skip the header row itself
    while index < array.length && array[index] != '--- scanner ' + (s+1).to_s + ' ---'
      positions[s] << array[index].split(',').map(&:to_i) unless array[index].empty?
      index += 1
    end
  end
end

parse_positions_array(positions_array, positions)

# all the transformations we're considering preserve distances. So we're first going to
# look at plausible overlaps by considering distances between every pair of beacons scanned
# by each scanner. If they contain 12 common beacons, then there must be 12*11/2 = 66
# common sets of distances - actually we'll look at the sq of distances as this will always
# be an integer so easier to compare

def distances_sq(positions)
  dist_sq = {}
  [*0..34].each do |s|
    distances_sq = {}
    points = positions[s]
    # puts "points = " + points.to_s
    [*0..points.length - 1].each do |i|
      [*i+1..points.length - 1].each do |j|
        distances_sq[[[points[i][0], points[i][1], points[i][2]], [points[j][0], points[j][1], points[j][2]]]] =
          ((points[i][0] - points[j][0]) * (points[i][0] - points[j][0]) +
            (points[i][1] - points[j][1]) * (points[i][1] - points[j][1]) +
            + (points[i][2] - points[j][2]) * (points[i][2] - points[j][2]))
      end
    end
    dist_sq[s] = distances_sq
  end
  dist_sq
end

# so what we'll do is for each pair of scanners find set of common distances_sq between pairs of points. We also know
# that we can remove any points that don't occur in at least 11 pairs (as there are 12 beacons) so need a helper method

def trim (coord_pairs)
  points = coord_pairs.flatten(1)
  unique_points = points.uniq
  unique_points.dup.each do |unique_point|
    unique_points.delete(unique_point) if points.count { |point| point == unique_point } < 11
  end
  unique_points
end

distances_sq = distances_sq(positions)
pairs_to_check = []
pairs_of_scanners_to_check = {}
[*0..34].each do |i|
  [*i+1..34].each do |j| # only compare each pair once, and don't compare scanner with itself
    pairs_i = distances_sq[i].keys.dup
    pairs_j = distances_sq[j].keys.dup

    # delete each pair_i from pairs_i, where value_i not in values_j
    # and delete each pair_j from pairs_j where value_j not in values_i
    pairs_i.reject! { |pair_i| !distances_sq[j].values.include?(distances_sq[i][pair_i]) }
    pairs_j.reject! { |pair_j| !distances_sq[i].values.include?(distances_sq[j][pair_j]) }

    # if we have 12 beacons in common, we must have at least 12 * 11 / 2 = 66 distances between them in common
    if pairs_i.length >= 66 && pairs_j.length >=66
      pairs_to_check << [i, j]
      beacon_set_i = trim(pairs_i)
      beacon_set_j = trim(pairs_j)
      # also need to check if both pairs_i and pairs_j represent a connected set of >= 12 points
      if beacon_set_i.length >= 12 && beacon_set_j.length >=12
        pairs_of_scanners_to_check[[i, j]] = [beacon_set_i, beacon_set_j]
      end
    end
  end
end

puts pairs_to_check.to_s

puts "matching beacon sets..."
pairs_of_scanners_to_check.keys.each do |pair|
  puts pair.to_s
  puts pairs_of_scanners_to_check[pair][0].to_s
  puts pairs_of_scanners_to_check[pair][1].to_s
end

# ok, now we know the pairs of scanners with overlapping beacon sets, we
# need a set of paths that visits each pair in turn so we can calculate the
# next scanner relative to the current one.
# First we need to make our map of scanners non-directed...
pairs_to_check.dup.each do |pair|
  pairs_to_check << pair.reverse
end

# need a recursive function
path = [0]
pairs = []
def traversal(pairs_to_check, path, pairs)
  next_pairs = pairs_to_check.select { |next_pair| next_pair.first == path.last && !path.include?(next_pair.last) }
  return path if next_pairs.length == 0

  # otherwise we can extend our path
  next_pairs.each do |pair|
    if !path.include?(pair.last)
      path << pair.last
      pairs << pair
      traversal(pairs_to_check, path, pairs)
    end
  end
end

traversal(pairs_to_check, path, pairs).to_s
puts path.to_s
puts pairs.to_s

# ok so inching closer.... for each of our pairs of scanners, we have our 12 beacons... we now need to correct
# the orientation of each scanner to match the previous scanner, and then work out the translation.

def match_beacons(beacon_set_0, beacon_set_1)
  sorted_set_0 = beacon_set_0.sort_by { |coords| coords[0] }
  sorted_set_1 = beacon_set_1.sort_by { |coords| coords[0] }
  result = true
  [*1..beacon_set_0.length - 1].each do |beacon|
    result &&= sorted_set_0[beacon][0] - sorted_set_1[beacon][0] == sorted_set_0[beacon - 1][0] - sorted_set_1[beacon - 1][0]
  end
  sorted_set_0 = beacon_set_0.sort_by { |coords| coords[1] }
  sorted_set_1 = beacon_set_1.sort_by { |coords| coords[1] }
  [*1..beacon_set_0.length - 1].each do |beacon|
    result &&= sorted_set_0[beacon][1] - sorted_set_1[beacon][1] == sorted_set_0[beacon - 1][1] - sorted_set_1[beacon - 1][1]
  end
  sorted_set_0 = beacon_set_0.sort_by { |coords| coords[2] }
  sorted_set_1 = beacon_set_1.sort_by { |coords| coords[2] }
  [*1..beacon_set_0.length - 1].each do |beacon|
    result &&= sorted_set_0[beacon][2] - sorted_set_1[beacon][2] == sorted_set_0[beacon - 1][2] - sorted_set_1[beacon - 1][2]
  end
  result
end

puts "+++++++++++++++"
puts "beacons 0 = " + pairs_of_scanners_to_check[[0, 8]][0].to_s
puts "beacons 8 = " + pairs_of_scanners_to_check[[0, 8]][1].to_s
puts "match = " + match_beacons(pairs_of_scanners_to_check[[0, 8]][0], pairs_of_scanners_to_check[[0, 8]][1]).to_s
# puts "match = " + match_beacons([[1,2],[3,4],[5,6]], [[3,4],[5,6],[7,8]]).to_s

def change_orientation(beacon_positions, transformation_type)
  case transformation_type # to realign to 'normal'
  when 0 # facing pos x, up = pos z
    # (x, y, z) -> (x, y, z) - no pos-swap, no sign-swap
    beacon_positions.map do |coords|
      coords
    end
  when 1 # facing pos x up = neg z
    # (x, y, z) -> (x, - y, - z) - no pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [coords[0], -1 * coords[1], -1 * coords[2]]
    end
  when 2 # facing pos x, up = pos y
    # (x, y, z) -> (x, z, -y) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[0], coords[2], -1 * coords[1]]
    end
  when 3 # facing pos x, up = neg y
    # (x, y, z) -> (x, -z, y) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[0], -1 * coords[2], coords[1]]
    end
  when 4 # facing neg x, up = pos z
    # (x, y, z) -> (-x, -y, z) - no pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[0], -1 * coords[1], coords[2]]
    end
  when 5 # facing neg x up = neg z
    # (x, y, z) -> (-x, y, -z) - no pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[0], coords[1], -1 * coords[2]]
    end
  when 6 # facing neg x, up = pos y
    # (x, y, z) -> (-x, z, y) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[0], coords[2], coords[1]]
    end
  when 7 # facing neg x, up = neg y
    # (x, y, z) -> (-x, -z, -y) - 1 pos-swap, 3 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[0], -1 * coords[2], -1 * coords[1]]
    end
  when 8 # facing pos y, up = pos x
    # (x, y, z) -> (z, x, y) - 2 pos-swap
    beacon_positions.map do |coords|
      [coords[2], coords[0], coords[1]]
    end
  when 9 # facing pos y up = neg x
    # (x, y, z) -> (-z ,x ,-y) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[2], coords[0], -1 * coords[1]]
    end
  when 10 # facing pos y, up = pos z
    # (x, y, z) -> (-y, x, z) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[1], coords[0], coords[2]]
    end
  when 11 # facing pos y, up = neg z
    # (x, y, z) -> (y, x, -z) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[1], coords[0], -1 * coords[2]]
    end
  when 12 # facing neg y, up = pos x
    # (x, y, z) -> (z, -x, -y) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [coords[2], -1 * coords[0], -1 * coords[1]]
    end
  when 13 # facing neg y up = neg x
    # (x, y, z) -> (-z, -x ,y) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[2], -1 * coords[0], coords[1]]
    end
  when 14 # facing neg y, up = pos z
    # (x, y, z) -> (y, -x, z) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[1], -1 * coords[0], coords[2]]
    end
  when 15 # facing neg y, up = neg z
    # (x, y, z) -> (-y, -x, -z) - 1 pos-swap, 3 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[1], -1 * coords[0], -1 * coords[2]]
    end
  when 16 # facing pos z, up = pos x
    # (x, y, z) -> (z, -y, x) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[2], -1 * coords[1], coords[0]]
    end
  when 17 # facing pos z up = neg x
    # (x, y, z) -> (-z, y, x) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[2], coords[1], coords[0]]
    end
  when 18 # facing pos z, up = pos y
    # (x, y, z) -> (y, z, x) - 2 pos-swap
    beacon_positions.map do |coords|
      [coords[1], coords[2], coords[0]]
    end
  when 19 # facing pos z, up = neg y
    # (x, y, z) -> (-y, -z, x) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[1], -1 * coords[2], coords[0]]
    end
  when 20 # facing neg z, up = pos x
    # (x, y, z) -> (z, y, -x) - 1 pos-swap, 1 sign-swap
    beacon_positions.map do |coords|
      [coords[2], coords[1], -1 * coords[0]]
    end
  when 21 # facing neg z up = neg x
    # (x, y, z) -> (-z, -y, -x) - 1 pos-swap, 3 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[2], -1 * coords[1], -1 * coords[0]]
    end
  when 22 # facing neg z, up = pos y
    # (x, y, z) -> (-y, z, -x) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [-1 * coords[1], coords[2], -1 * coords[0]]
    end
  when 23 # facing neg z, up = neg y
    # (x, y, z) -> (y, -z, -x) - 2 pos-swap, 2 sign-swap
    beacon_positions.map do |coords|
      [coords[1], -1 * coords[2], -1 * coords[0]]
    end
  end
end

# ok, so now we can put it all together
# translation = position of each scanner relative to position of scanner 0
# beacons = set of beacons relative to scanner 0
def scanners_and_beacons(pairs, pairs_of_scanners_to_check, translations, scanners, beacons, types)
  pairs.each do |pair|
    if pairs_of_scanners_to_check.keys.include?(pair)
      beacon_set_0 = pairs_of_scanners_to_check[pair][0]
      beacon_set_1 = pairs_of_scanners_to_check[pair][1]
    else
      beacon_set_0 = pairs_of_scanners_to_check[pair.reverse][1]
      beacon_set_1 = pairs_of_scanners_to_check[pair.reverse][0]
    end
    # need to adjust our beacon_set_0 so relative to origin - can always do as either
    # it is the origin or we'll already have relative position/orientation of current scanner
    # relative to the origin...
    adj_beacon_set_0 = change_orientation(beacon_set_0, types[pair[0]]).map do |beacon|
      [beacon[0] += translations[pair[0]][0],
      beacon[1] += translations[pair[0]][1],
      beacon[2] += translations[pair[0]][2]]
    end
    type = 0
    while type < 24 && !match_beacons(adj_beacon_set_0, change_orientation(beacon_set_1, type))
      type += 1
    end
    types[pair[1]] = type
    # we now need to calculate the translation/orientation of scanner relative to previous scanner
    sorted_beacon_set_0 = adj_beacon_set_0.sort_by { |coords| coords.first }
    sorted_beacon_set_1 = change_orientation(beacon_set_1, type).sort_by { |coords| coords.first }
    # get our new translation relative to previous scanner
    translations[pair[1]] = translations[0].dup
    translations[pair[1]][0] += sorted_beacon_set_0[0][0] - sorted_beacon_set_1[0][0]
    translations[pair[1]][1] += sorted_beacon_set_0[0][1] - sorted_beacon_set_1[0][1]
    translations[pair[1]][2] += sorted_beacon_set_0[0][2] - sorted_beacon_set_1[0][2]
    # record the position of our scanner relative to scanner 0
    scanners[pair[1]] = [translations[0], translations[1], translations[2]]
    # record the position of our beacons relative to scanner 0
    beacons[pair[1]] = []
    sorted_beacon_set_1.each do |beacon|
      beacons[pair[1]] << [beacon[0] + translations[pair[1]][0], beacon[1] + translations[pair[1]][1], beacon[2] + translations[pair[1]][2]]
    end
  end
end

scanners = { 0 => [0, 0, 0] }
beacons = { 0 => [] }
translations = { 0 => [0, 0, 0] }
types = { 0 => 0 }
scanners_and_beacons(pairs, pairs_of_scanners_to_check, translations, scanners, beacons, types)

puts "translations = " + translations.to_s
puts "scanners = " + scanners.to_s
puts "beacons = " + beacons.to_s
puts "types = " + types.to_s

# so, we are now in a position to map all our beacons.
total_beacons = []
positions.keys.each do |scanner|
  puts scanner
  puts positions[scanner].to_s
  change_orientation(positions[scanner], types[scanner]).map do |beacon|
    total_beacons << [beacon[0] += translations[scanner][0],
     beacon[1] += translations[scanner][1],
     beacon[2] += translations[scanner][2]]
  end
end
puts "_______________________"
puts total_beacons.uniq.length

###### PART 2 ######

# we have our translations...
max = 0
[*0..translations.keys.length - 1].each do |index_1|
  [*index_1..translations.keys.length - 1].each do |index_2|
    md = (translations[index_1][0] - translations[index_2][0]).abs +
      (translations[index_1][1] - translations[index_2][1]).abs +
      (translations[index_1][2] - translations[index_2][2]).abs
    max = [max, md].max
  end
end

puts max