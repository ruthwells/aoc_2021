# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
inputs = data_array.map { |entry| entry.strip.chars }

match = { '[' => ']', '{' => '}', '(' => ')', '<' => '>' }
error_score = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
unmatched_score = { '[' => 2, '{' => 3, '(' => 1, '<' => 4 }


# go through each set, each time you see an opening symbol add
# to stack. Each time you see a closing symbol, if it matches
# top of stack pop the top of the stack, otherwise raise error
score = 0
unmatched_syms = []

inputs.each do |syms|
  remaining = syms.dup
  stack = []
  syms.each do |sym|
    if match.keys.include?(sym)
      stack.append(sym)
      remaining.shift
    else
      if stack.length > 0
        if sym == match[stack[-1]] # matching pair
          stack.pop
          remaining.shift
        else # error so log it and stop here
          score += error_score[sym]
          puts("expected: " + match[stack[-1]] + " found: " + sym)
          break
        end
      else # error: stack.length == 0 so closing without opening
        score += error_score[sym]
        puts("expected: " + match[stack[-1]] + " found nothing")
        break
      end
    end
  end
  puts stack.to_s
  if stack.length > 0 && remaining.length == 0 # matched what we can with no errors but not finished
    unmatched_syms << stack.reverse #reverse as will need to close the last open symbol first
  end
end

puts score

completion_scores = unmatched_syms.each_with_object([]) do |syms, scores|
  puts syms.to_s
  score = 0
  syms.each { |sym| score = (score * 5) + unmatched_score[sym] }
  scores << score
end

puts completion_scores.sort![(completion_scores.length - 1)/2]
