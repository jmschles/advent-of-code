VOWELS = %w(a e i o u)
NAUGHTY_PAIRS = %w(ab cd pq xy)

def enough_vowels?(str)
  str.chars.select { |c| VOWELS.include?(c) }.count >= 3
end

def has_double_letter?(str)
  str.squeeze.length < str.length
end

def has_naughty_pair?(str)
  NAUGHTY_PAIRS.any? { |pair| str.include?(pair) }
end

# ugh
def has_double_pair?(str)
  all_pairs = []
  (0..str.length - 2).each { |i| all_pairs << str[i] + str[i+1] }
  doubles = all_pairs.select { |pair| all_pairs.count(pair) >= 2 }.uniq
  doubles.each do |double|
    indices_of_double = all_pairs.each_index.select { |i| all_pairs[i] == double }
    (0..indices_of_double.length - 2).each do |idx|
      if (indices_of_double[idx] - indices_of_double[idx+1]).abs > 1 || indices_of_double.count > 2
        return true
      end
    end
  end
  false
end

def has_sammich?(str)
  (0..str.length - 3).each { |i| return true if str[i] == str[i+2] }
  false
end

nice_count = 0

### PART 1
# File.open('input.txt').each_line do |line|
#   next if line.empty?
#   str = line.chomp
#   if (enough_vowels?(str) && has_double_letter?(str)) && !has_naughty_pair?(str)
#     nice_count += 1
#   end
# end

### PART 2
File.open('input.txt').each_line do |line|
  next if line.empty?
  str = line.chomp
  if has_double_pair?(str) && has_sammich?(str)
    nice_count += 1
  end
end

puts nice_count
