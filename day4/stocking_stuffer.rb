require 'digest'

SECRET_KEY = 'yzbqklnj'
ZERO_REQUIREMENT = 5

found = false
candidate = 0

until found
  md5 = Digest::MD5.new
  md5 << SECRET_KEY + candidate.to_s
  if md5.hexdigest[0..ZERO_REQUIREMENT - 1] == '0' * ZERO_REQUIREMENT
    found = true
    break
  end
  candidate += 1
end

puts candidate
