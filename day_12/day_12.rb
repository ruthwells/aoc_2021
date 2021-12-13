# frozen_string_literal: true

data_array = File.readlines('data_file.txt')

# get our edges
edges = []
data_array.each_with_object(edges) do |entry, edges|
  pair = entry.strip.split('-')
  edges << pair
  edges << pair.reverse
end

# get a set of nodes, with whether small- or big-
nodes = edges.flatten.uniq.each_with_object({}) do |cave, hash|
  cave.downcase == cave || cave == 'start' ? hash[cave] = 'small' : hash[cave] = 'big'
end

completed_paths = []

def paths(nodes, edges, start, finish, path_so_far, completed_paths)
  path_so_far << start
  # termination conditions
  if start == finish
    return completed_paths << path_so_far
  end

  # otherwise use recursion
  available_edges = edges.select { |edge| edge[0] == start }.reject { |edge| path_so_far.include?(edge[1]) && nodes[edge[1]] == 'small'}
  available_edges.each { |edge| paths(nodes, edges, edge[1], finish, path_so_far.dup, completed_paths) }
end

paths(nodes, edges, 'start', 'end',[], completed_paths).to_s
puts completed_paths.count