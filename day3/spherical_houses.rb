DIRECTION_PARSER = {
  '<' => :west,
  '>' => :east,
  'v' => :south,
  '^' => :north
}

class Santa
  attr_accessor :x_pos, :y_pos, :active

  def initialize(name)
    @name = name
    @active = false
    @x_pos = 0
    @y_pos = 0
  end
end

class HouseMap
  attr_reader :grid, :santas

  def initialize(santas)
    @santas = santas
    @santas.first.active = true
    @grid = [[1]]
  end

  def move_and_deliver(dir)
    send(:"move_#{ dir }")
    grid[active_santa.y_pos][active_santa.x_pos] += 1
    switch_santas
  end

  def move_west
    if active_santa.x_pos == 0
      add_new_column(:west)
      inactive_santa.x_pos += 1
    else
      active_santa.x_pos -= 1
    end
  end

  def move_east
    add_new_column(:east) if active_santa.x_pos == map_width - 1
    active_santa.x_pos += 1
  end

  def move_south
    add_new_row(:south) if active_santa.y_pos == map_height - 1
    active_santa.y_pos += 1
  end

  def move_north
    if active_santa.y_pos == 0
      add_new_row(:north)
      inactive_santa.y_pos += 1
    else
      active_santa.y_pos -= 1
    end
  end

  def add_new_row(dir)
    operation = dir == :north ? :unshift : :push
    grid.send(operation, [0] * map_width)
  end

  def add_new_column(dir)
    operation = dir == :west ? :unshift : :push
    grid.each { |row| row.send(operation, 0) }
  end

  def map_width
    grid.first.length
  end

  def map_height
    grid.length
  end

  def switch_santas
    santas.each { |s| s.active = !s.active }
  end

  def active_santa
    santas.select(&:active).first
  end

  def inactive_santa
    santas.reject(&:active).first
  end
end

santas = [Santa.new('Santa'), Santa.new('RoboSanta')]
house_map = HouseMap.new(santas)

File.open('input.txt').each_char do |char|
  next unless %w(< > v ^).include?(char)
  house_map.move_and_deliver(DIRECTION_PARSER[char])
end

puts house_map.grid.flatten.select { |h| h > 0 }.count
