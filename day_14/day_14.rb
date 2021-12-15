# frozen_string_literal: true

data_array = File.readlines('data_file.txt')

insertion_rules = {}
template = ''

data_array.each do |entry|
  if entry.include?(' -> ')
    insertion_rules[entry.strip.split(' -> ')[0].chars] = entry.strip.split(' -> ')[1]
  else
    template = entry.strip.chars unless entry.strip.empty?
  end
end

def process_template(template, insertion_rules, n)
  return template if n == 0

  result = []
  while template.length > 1
    insertion_element = insertion_rules[template[0..1]]
    result.append(template.shift)
    result.append(insertion_element) unless insertion_element.nil?
  end
  process_template(result.append(template[0]), insertion_rules, n - 1)
end


answer = process_template(template, insertion_rules, 10)
unique_els = answer.uniq

empty_counts = unique_els.each_with_object({}) { |entry, counts| counts[entry] = 0 }
final_counts = answer.each_with_object(empty_counts) { |letter, counts| counts[letter] += 1 }

puts final_counts.values.max - final_counts.values.min