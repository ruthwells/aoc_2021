# frozen_string_literal: true

p1_start = 5 #4
p2_start = 9 #8

# otherwise from 3 throws p1 can roll the following total scores with frequencies (total freq = 3*3*3 = 27)
die_roll_freqs = {}
die_roll_freqs[3] = 1
die_roll_freqs[4] = 3
die_roll_freqs[5] = 6
die_roll_freqs[6] = 7
die_roll_freqs[7] = 6
die_roll_freqs[8] = 3
die_roll_freqs[9] = 1

puts die_roll_freqs.to_s

cached = {}

puts cached.to_s

# first parameter is player who will play first (0 or 1)
# positions = starting positions, e.g. {0 => 4, 1 => 8}
# scores = starting scores e.g. {0 => 0, 1 => 0}
# wins = wins per player so far {0 => 123, 1 => 456}
def game_wins(next_player, positions, scores, wins, die_roll_freqs, cached)
  # termination condition: check if p2 has just won
  if scores[1 - next_player] >= 21
    wins[1 - next_player] += 1
    #puts " " * depth + "returning " + wins.to_s
    return wins
  end

  # otherwise, we need each of the possible universes for the next 3 rolls
  result = [0, 0]
  die_roll_freqs.keys.each do |die_roll|
    # clone our current position for the new universe
    positions_clone = positions.dup
    scores_clone = scores.dup
    positions_clone[next_player] = (positions_clone[next_player] + die_roll - 1) % 10 + 1
    scores_clone[next_player] += positions_clone[next_player]

    # see if we've already seen this new game already - if not we'll want to cache the result
    # remember other player gets to go first in next game, next_player -> 1 - next_player
    # and wins for one player with a set of positions/scores = wins for other player with positions/scores reversed
    unless cached.keys.include?([1 - next_player, positions_clone, scores_clone]) &&
              cached.keys.include?([next_player, positions_clone.reverse, scores_clone.reverse])

      cached[[1 - next_player, positions_clone, scores_clone]] =
        game_wins(1 - next_player, positions_clone, scores_clone, [0,0], die_roll_freqs, cached)
      cached[[next_player, positions_clone.reverse, scores_clone.reverse]] =
        cached[[1 - next_player, positions_clone, scores_clone]].reverse
    end
    # use our cache
    result[0] += (cached[[1 - next_player, positions_clone, scores_clone]][0] * die_roll_freqs[die_roll])
    result[1] += (cached[[1 - next_player, positions_clone, scores_clone]][1] * die_roll_freqs[die_roll])
  end
  return result
end

depth = 0
wins = [0, 0]
final_wins = game_wins(0, [p1_start,p2_start], [0,0], wins, die_roll_freqs, cached)
puts final_wins.to_s
puts final_wins.max
