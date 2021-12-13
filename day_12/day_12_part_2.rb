# frozen_string_literal: true

data_array = File.readlines('data_file.txt')

# get our edges
edges = []
data_array.each_with_object(edges) do |entry, edges|
  pair = entry.strip.split('-')
  edges << pair
  edges << pair.reverse
end

# get a set of nodes, with whether small- or big- visit
nodes = edges.flatten.uniq.each_with_object({}) do |cave, hash|
  cave.downcase == cave || cave == 'start' ? hash[cave] = 'small' : hash[cave] = 'big'
end

def paths(nodes, edges, start, finish, path_so_far, completed_paths, node_for_two_visits)
  # bit of a hack for the small node that can be visited twice
  if node_for_two_visits == start && path_so_far.include?(start)
    path_so_far << start + start
  else
    path_so_far << start
  end

  # termination conditions
  if start == finish
    return completed_paths << path_so_far
  end

  # otherwise use recursion - now allowed to visit a small node twice
  available_edges = edges.select { |edge| edge[0] == start }.reject do |edge|
    nodes[edge[1]] == 'small' && node_for_two_visits == edge[1] && path_so_far.include?(edge[1] + edge[1]) ||
      nodes[edge[1]] == 'small' && node_for_two_visits != edge[1] && path_so_far.include?(edge[1])
  end
  available_edges.each { |edge| paths(nodes, edges, edge[1], finish, path_so_far.dup, completed_paths, node_for_two_visits) }
end

# so taking each of the small caves in turn, and allowing this to be visisted twice, unless they are start/end
total_completed_paths = []
nodes.keys.each do |cave|
  if nodes[cave] == 'small' && cave != 'start' && cave != 'end'
    completed_paths = []
    paths(nodes, edges, 'start', 'end', [], completed_paths, cave)
    total_completed_paths += completed_paths
  end
end

puts total_completed_paths.uniq.count