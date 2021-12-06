# get array

data_array = File.readlines('data_1.txt')
# get size of array
len = data_array.length
# initialize our count
count_checks = 0
count_increases = 0
# ignore 1st item as no, BUT REMEMBER RUBY ARRAY INDEXING IS 0 BASED!!!!!!!
for n in 3..len-1 do
  puts data_array[n].to_i, data_array[n-1].to_i, "______"
  count_checks += 1
  if data_array[n].to_i > data_array[n-3].to_i
    count_increases += 1
  end
end
puts count_increases, count_checks


