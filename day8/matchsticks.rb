### PART 1
# code_chars = 0
# real_chars = 0

# File.open('input.txt').each_line do |line|
#   line = line.chomp
#   real_chars += line.length
#   code_chars += eval(line).length
# end

### PART 2
code_chars = 0
esc_chars = 0
File.open('input.txt').each_line do |line|
  line = line.chomp
  code_chars += line.length
  esc_chars += line.dump.length
end

puts esc_chars - code_chars
