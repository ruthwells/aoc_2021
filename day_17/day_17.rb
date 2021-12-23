# frozen_string_literal: true

x_min = 29
x_max = 73

y_min = -248
y_max = -194

allowed_positions = [*x_min..x_max].product([*y_min..y_max])

puts allowed_positions.to_s

# by inspection, we know that if x_vel is too small we won't reach the block
# and if x_vel is too big, then the only way we'll hit the block is by 
# having y very small. Aim for x_vel = 0 over the block

def check_trajectory(x_vel, y_vel, y_min, allowed_positions)
  t = 1
  x = 0
  y = 0
  y_set = []
  ok = false
  while y > y_min # otherwise we'll be past the target anyway
    x += x_vel
    y += y_vel
    y_set << y
    #puts [t, x, y].to_s
    ok = true if allowed_positions.include?([x, y])
    t += 1
    x_vel -= 1 if x_vel > 0
    y_vel -= 1
  end
  ok ? y_set.max : -100
end

[6, 7, 8, 9].each do |x_vel|
  puts "========= x-vel = " + x_vel.to_s + "==============="
  [*1..250].each do |y_vel|
    puts check_trajectory(x_vel, y_vel, -248, allowed_positions)
  end
end

