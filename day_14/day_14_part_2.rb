# frozen_string_literal: true

# approach for part 2 is that we think of each template as an array, e.g.
# "NNCB" -> ["*N", "NN", "NC", "CB", "B*"]. Then we know from our mappings,
# that e.g. CB -> H means that every time we see "CB" in our array, it is
# removed and replaced with "CH" and "CB". So now, rather than work with
# the template, we can work with just the counts of pairs in the template,
# starting with { "*N" => 1, "NN" => 1, "NC" => 1, "CB" => 1, "B*" => 1,
# everything_else => 0 } which has fixed size however many steps we have.
# Note the 'dummy' pairs at the start and finish - these never change, but
# mean that the frequency of any element in the pairs array is always exactly
# double the frequency of the element in the actual array and makes for easier
# calculations

# hash of insertion mappings as above, e.g. "CB" => ["CH", "CB"]
insertion_rules = {}
# count of pairs in our template array, e.g. { "*N" => 1, "NN" => 1, ... }
counts_hash = {}
# 'paired' representation of our starting template e.g. ["*N", "NN", "NC", "CB", "B*"]
template_pairs = ''
# count of elements in the template, e.g. {"C"=>1, "H"=>0, "B"=>1, "N"=>2}
# straightforward to deduce from the count of pairs in our hash
element_counts = {}

# helper methods...

# ... to transform a string into an array of pairs, e.g. "fred" => ["fr", "re", "ed"]
def get_pairs(string)
  [*0..(string.length - 2)].each_with_object([]) do |n, pairs|
    pairs << string[n..n + 1]
  end
end

# ... to get the count of each element from the counts_hash for pairs
def counts_from_counts_hash(counts_hash, element_counts)
  counts_hash.each do |pair, count|
    pair.chars.each do |char|
      element_counts[char] += count unless char == '*'
    end
  end
  # remember our pairs count every element twice
  element_counts.dup.keys.each do |el|
    element_counts[el] = element_counts.dup[el] / 2
  end
end


# prep

data_array = File.readlines('data_file.txt')

data_array.each do |entry|
  if entry.include?(' -> ')
    rule_parts = entry.strip.split(' -> ')
    # populate our insertion rules
    # CB -> H becomes "CB" => ["CH", "CB"] in our hash
    insertion_rules[rule_parts[0]] = [rule_parts[0][0] + rule_parts[1], rule_parts[1] + rule_parts[0][1]]
    # initialize our element counts - need to look through rules to find every
    # possible letter that can be included in the template - we may visit the
    # same letter twicewhile doing this, but it only has to be done once,
    # and it's a relatively tiny set
    element_counts[rule_parts[0][0]] = 0
    element_counts[rule_parts[0][1]] = 0
    element_counts[rule_parts[1]] = 0
    # initialize our counts hash - again need to find every possible pair that
    # can end up in the template from the mappings. Again fine if we visit some
    # twice - it's only done once and you can't end up with duplicate keys in hash
    counts_hash[rule_parts[0]] = 0
    counts_hash[rule_parts[0][0] + rule_parts[1]] = 0
    counts_hash[rule_parts[1] + rule_parts[0][1]] = 0
  else
    # read our starting template and make into an array of pairs
    template_pairs = get_pairs(entry.strip) unless entry.strip.empty?
  end
end

# we also need to add the dummy first and last pairs, using
# the first and last characters of the template, and include
# in counts_hash
template_pairs.prepend('*' + template_pairs.first[0])
template_pairs.append(template_pairs.last[1] + '*')
# finish initializing our counts_hash
counts_hash[template_pairs.first] = 0
counts_hash[template_pairs.last] = 0
# and populate counts_hash from our starting template
template_pairs.each { |pair| counts_hash[pair] += 1 }


# finally we are good to do some processing, given the fiddly
# prep, this bit is remarkably easy to do!

def process_template(counts_hash, insertion_rules, n)
  return if n.zero?

  # because we need to modify count_hash as we iterate over
  # it, we iterate over a dup of it
  counts_hash.dup.each do |pair, count|
    unless pair.include?('*') # dummy pairs never change - just for final counts
      counts_hash[pair] -= count
      insertion_rules[pair].each do |mapped_pair|
        counts_hash[mapped_pair] += count
      end
    end
  end
  process_template(counts_hash, insertion_rules, n - 1)
end

# and use our functions...
# ... to process the template for 40 steps
process_template(counts_hash, insertion_rules, 40)
# ... and populate the count of individual elements
counts_from_counts_hash(counts_hash, element_counts).to_s

puts (element_counts.values.max - element_counts.values.min)