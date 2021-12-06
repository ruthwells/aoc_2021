# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
# split the data into bingo numbers and boards
bingo_nos = data_array.shift().split(',')
# data_array.map { |row| row.split }
bingo_boards = data_array.map { |row| row.to_s.strip.split(' ') }

incomplete_boards = []
for n in 0..bingo_boards.length / 6 - 1
  incomplete_boards.append(n)
end
puts incomplete_boards.to_s

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

def play_game(boards, incomplete_board_numbers, bingo_numbers, n)

  return if n >= bingo_numbers.length

  new_boards = mark_boards(boards, bingo_numbers[n])

  # see if we have a full house
  incomplete_board_numbers.each do |i|
    row_sums = [0, 0, 0, 0, 0]
    col_sums = [0, 0, 0, 0, 0]

    (0..24).each do |j|
      row_sums[j / 5] += new_boards[6 * i + 1 + j / 5][j % 5].to_i
      col_sums[j % 5] += new_boards[6 * i + 1 + j / 5][j % 5].to_i
    end

    if row_sums.include?(500) or col_sums.include?(500)
      # we need to do the calculations....
      incomplete_board_numbers.reject!{ |num| num == i }

      # have we just completed the final board?....
      if incomplete_board_numbers.length == 0
        puts sum_unmarked(boards, i) * bingo_numbers[n].to_i
        return
      end

    end
  end

  play_game(new_boards, incomplete_board_numbers, bingo_numbers, n+1)
end

puts play_game(bingo_boards, incomplete_boards, bingo_nos, 0)
