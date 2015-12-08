class LightField
  attr_reader :grid

  def initialize
    @grid = Array.new(1000) { Array.new([0] * 1000) }
  end

  def turnon(start_pos, end_pos)
    (start_pos[0]..end_pos[0]).each do |row|
      (start_pos[1]..end_pos[1]).each do |col|
        @grid[row][col] += 1
      end
    end
  end

  def turnoff(start_pos, end_pos)
    (start_pos[0]..end_pos[0]).each do |row|
      (start_pos[1]..end_pos[1]).each do |col|
        @grid[row][col] -= 1 if @grid[row][col] > 0
      end
    end
  end

  def toggle(start_pos, end_pos)
    (start_pos[0]..end_pos[0]).each do |row|
      (start_pos[1]..end_pos[1]).each do |col|
        @grid[row][col] += 2
      end
    end
  end

  def total_brightness
    @grid.flatten.inject(&:+)
  end
end

def parse_line(line)
  split_line = line.chomp.split
  start_pos, end_pos = [split_line[-3], split_line[-1]].map { |pair| pair.split(',').map(&:to_i) }
  operation = split_line.count == 5 ? split_line.first(2).join : split_line.first
  [operation.to_s, start_pos, end_pos]
end

light_field = LightField.new

File.open('input.txt').each_line do |line|
  next if line.empty?
  operation, start_pos, end_pos = parse_line(line)
  light_field.send(operation, start_pos, end_pos)
end

puts light_field.total_brightness
