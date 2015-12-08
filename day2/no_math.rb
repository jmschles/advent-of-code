class Box
  attr_reader :dimensions

  def initialize(dimensions)
    @dimensions = dimensions
  end

  def wrapping_paper_needed
    total_surface_area + smallest_side_area
  end

  def ribbon_needed
    shortest_perimeter + volume
  end

  private

  def smallest_side_area
    dimensions.min(2).inject(&:*)
  end

  def total_surface_area
    dimensions.combination(2).map { |side| side.inject(&:*) }.inject(&:+) * 2
  end

  def volume
    dimensions.inject(&:*)
  end

  def shortest_perimeter
    dimensions.min(2).inject(&:+) * 2
  end
end

total_ribbon = 0
total_wrapping_paper = 0

File.open('input.txt').each_line do |line|
  next if line.empty?
  box = Box.new(line.chomp.split('x').map(&:to_i))
  total_wrapping_paper += box.wrapping_paper_needed
  total_ribbon += box.ribbon_needed
end

puts "WRAPPING PAPER: #{ total_wrapping_paper }"
puts "RIBBON: #{ total_ribbon }"
