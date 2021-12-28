# frozen_string_literal: true

p1_start = 5
p2_start = 9

def outcomes(p1_pos, p2_pos, die_pos)
  p1_score = 0
  p2_score = 0
  finished = false
  num_rolls = 0
  until finished
    p1_roll = 0
    p2_roll = 0
    [*1..3].each do |roll|
      p1_roll += die_pos
      die_pos = (die_pos % 100) + 1
      num_rolls += 1
    end
    p1_pos = (p1_pos + p1_roll - 1) % 10 + 1
    p1_score += p1_pos

    puts "Player 1 rolls " + p1_roll.to_s + " and moves to space " + p1_pos.to_s + " for a total score of " + p1_score.to_s + ", num rolls = " + num_rolls.to_s
    break if p1_score >= 1000

    [*1..3].each do |roll|
      p2_roll += die_pos
      die_pos = (die_pos % 100) + 1
      num_rolls += 1
    end
    p2_pos = (p2_pos + p2_roll - 1) % 10 + 1
    p2_score += p2_pos

    puts "Player 2 rolls moves to space " + p2_pos.to_s + " for a total score of " + p2_score.to_s + ", num rolls = " + num_rolls.to_s
    break if p2_score >= 1000
  end

  return [p1_score, p2_score].min * num_rolls
end


puts outcomes(5, 9, 1)