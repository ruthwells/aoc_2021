# frozen_string_literal: true

data_array = File.readlines('data_file.txt')
inputs = data_array.map { |entry| entry.strip.chars }

match = { '[' => ']', '{' => '}', '(' => ')', '<' => '>' }
error_score = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }


# go through each set, each time you see an opening symbol add
# to stack. Each time you see a closing symbol, if it matches
# top of stack pop the top of the stack, otherwise raise error
score = 0

inputs.each do |syms|
  stack = []
  puts "+++++++++++++"
  syms.each do |sym|
    if match.keys.include?(sym)
      stack.append(sym)
    else
      if stack.length == 0 # incomplete string
        break
      elsif sym == match[stack[-1]] # matching pair
        stack.pop
      else # error so log it and stop here
        puts "expected: " + match[stack[-1]] + " found: " + sym
        score += error_score[sym]
        break
      end
    end
  end
end

puts score