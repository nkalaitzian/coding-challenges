f = File.open('/home/nkalaitzian/Documents/advent-of-code/2021/2/input.txt')
lines = f.readlines.map(&:chomp)
f.close

h = 0
v = 0

lines.each do |l|
  case l.strip
  when /forward\s+\d+/
    h += l.gsub(/forward\s+/, '').strip.to_i
  when /up\s+\d+/
    v -= l.gsub(/up\s+/, '').strip.to_i
  when /down\s+\d+/
    v += l.gsub(/down\s+/, '').strip.to_i
  else
  end
end
puts "V: #{v} H:#{h} - result: #{v * h}"

h = 0
v = 0
a = 0

lines.each do |l|
  case l.strip
  when /forward\s+\d+/
    h += l.gsub(/forward\s+/, '').strip.to_i
    v += (l.gsub(/forward\s+/, '').strip.to_i * a)
  when /up\s+\d+/
    # v -= l.gsub(/up\s+/, '').strip.to_i
    a -= l.gsub(/up\s+/, '').strip.to_i
  when /down\s+\d+/
    # v += l.gsub(/down\s+/, '').strip.to_i
    a += l.gsub(/down\s+/, '').strip.to_i
  else
  end
end

puts "V: #{v} H:#{h} A:#{a} - result: #{v * h}"
