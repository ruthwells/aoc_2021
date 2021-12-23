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

def check_trajectory(x_start, y_start, y_min, allowed_positions, allowed_vels)
  t = 1
  x = 0
  y = 0
  x_vel = x_start
  y_vel = y_start
  y_set = []
  ok = false
  while y > y_min && !ok # this time can stop as soon as we find just one!
    x += x_vel
    y += y_vel
    y_set << y
    #puts [t, x, y].to_s
    ok = true if allowed_positions.include?([x, y])
    t += 1
    x_vel -= 1 if x_vel > 0
    y_vel -= 1
  end
  #  puts [x_start, y_start].to_s if ok
  allowed_vels << [x_start, y_start] if ok
end

# this is not at all neat.... got extremes using a bit of binary search and trial and error
# this is a definite bruting it...

allowed_vels = []
[*8..73].each do |x_vel|
  puts x_vel
  [*-250..250].each do |y_vel|
    check_trajectory(x_vel, y_vel, -248, allowed_positions, allowed_vels).to_s
  end
  #  puts allowed_vels.to_s
end

puts allowed_vels.length