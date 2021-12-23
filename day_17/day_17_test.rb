# frozen_string_literal: true

x_min = 20
x_max = 30

y_min = -10
y_max = -5

allowed_positions = [*x_min..x_max].product([*y_min..y_max])

puts allowed_positions.to_s

# by inspection, we know that if x_vel is too small we won't reach the block
# and if x_vel is too big, then the only way we'll hit the block is by 
# having y very small. Aim for x_vel = 0 over the block

def check_trajectory(x_vel, y_vel, y_min, allowed_positions)
  t = 1
  x = 0
  y_set = []
  ok = false
  while (y_vel * t - 0.5 * t * t) > y_min # otherwise we'll be past the target anyway
    x += x_vel
    y = y_vel * t - 0.5 * t * t
    y_set << y
    #puts [t, x, y].to_s
    ok = true if allowed_positions.include?([x, y])
    t += 1
    x_vel -= 1 if x_vel > 0
  end
  ok ? [y_vel, y_set.max].to_s : -100
end

[6, 7].each do |x_vel|
  [*1..20].each do |y_vel|
    puts check_trajectory(x_vel, y_vel, -10, allowed_positions)
  end
end

