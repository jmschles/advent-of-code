require 'set'

distance_map = {}
all_destinations = Set.new
paths = {}

File.open('input.txt').each_line do |line|
  next if line.empty?
  places, distance_str = line.chomp.split(' = ')
  places.split(' to ').each { |place| all_destinations.add(place) }
  distance_map[places.split(' to ')] = distance_str.to_i
  distance_map[places.split(' to ').reverse] = distance_str.to_i
end

all_destinations.to_a.permutation.each do |perm|
  paths[perm] = 0
  perm.each_with_index do |destination, i|
    next if i >= perm.length - 1
    paths[perm] += distance_map[[perm[i], perm[i+1]]]
  end
end

### PART 1
# puts paths.values.min

### PART 2
puts paths.values.max
