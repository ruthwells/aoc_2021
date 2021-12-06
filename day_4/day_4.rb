# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
# split the data into bingo numbers and boards
bingo_nos = data_array.shift().split(',')
# data_array.map { |row| row.split }
bingo_boards = data_array.map { |row| row.to_s.strip.split(' ') }


# mark all instances of the number called by changing to 100
def mark_boards(boards, called)
  boards.each do |row|
    row.map! { |entry| entry == called ? 100 : entry }
  end
  boards
end

def sum_unmarked(boards, board_no)
  sum = 0
  for i in 1..5
    boards[6*board_no + i].each do |entry|
     sum += entry.to_i if entry.to_i != 100
    end
  end
  sum
end

def play_game(boards, numbers, n)

  return if n >= numbers.length

  new_boards = mark_boards(boards, numbers[n])

  # see if we have a full house
  num_boards = new_boards.length / 6

  (0..num_boards-1).each do |i|
    row_sums = [0, 0, 0, 0, 0]
    col_sums = [0, 0, 0, 0, 0]

    (0..24).each do |j|
      row_sums[j / 5] += new_boards[6 * i + 1 + j / 5][j % 5].to_i
      col_sums[j % 5] += new_boards[6 * i + 1 + j / 5][j % 5].to_i
    end

    if row_sums.include?(500) or col_sums.include?(500)
      # we need to do the calculations....
      puts sum_unmarked(new_boards, i) * numbers[n].to_i
      return

    end
  end

  play_game(new_boards, numbers, n+1)
end

puts play_game(bingo_boards, bingo_nos, 0)

