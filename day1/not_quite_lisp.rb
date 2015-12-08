current_floor = 0
current_pos = 0
basement_reached = false

File.open('input.txt').each_char do |char|
  next unless [')', '('].include?(char)
  current_pos += 1
  operator = (char == '(' ? :+ : :-)
  current_floor = current_floor.send(operator, 1)
  if !basement_reached && current_floor < 0
    puts "basement reached at position #{ current_pos }"
    basement_reached = true
  end
end

puts current_floor
