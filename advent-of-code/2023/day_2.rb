input = ['Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'];
file_contents = File.open('day_2.txt', 'r').read
input = file_contents.split("\n").map { |ei| ei.split("\n") }.reject { |str| str == "" }.flatten

max_cubes = { red: 12, green: 13, blue: 14 }

game_id_matcher = /Game (?<index>\d+)/
red_matcher = /(?<reds>\d+) red/
blue_matcher = /(?<blues>\d+) blue/
green_matcher = /(?<greens>\d+) green/
ids_sum = 0
input.each do |game|
  game_index = game.match(game_id_matcher)[:index]
  matches = game.split(':').last.split(';').map(&:strip)
  is_any_match_impossible = false
  matches.each do |m|
    reds = m.match(red_matcher)&.[](:reds).to_i
    blues = m.match(blue_matcher)&.[](:blues).to_i
    greens = m.match(green_matcher)&.[](:greens).to_i

    if reds > max_cubes[:red] || blues > max_cubes[:blue] || greens > max_cubes[:green]
      is_any_match_impossible = true
      break
    end
  end

  if is_any_match_impossible
    puts "Game #{game_index} is impossible"
  else
    puts "Game #{game_index} is possible"
    ids_sum += game_index.to_i
  end
end; 0

puts "Total sum of ids: #{ids_sum}"

##### Part 2

game_id_matcher = /Game (?<index>\d+)/
red_matcher = /(?<reds>\d+) red/
blue_matcher = /(?<blues>\d+) blue/
green_matcher = /(?<greens>\d+) green/
game_power_sum = 0
input.each do |game|
  game_index = game.match(game_id_matcher)[:index]
  matches = game.split(':').last.split(';').map(&:strip)
  is_any_match_impossible = false
  max_reds, max_blues, max_greens = [-1, -1, -1]
  matches.each do |m|
    reds = m.match(red_matcher)&.[](:reds).to_i
    blues = m.match(blue_matcher)&.[](:blues).to_i
    greens = m.match(green_matcher)&.[](:greens).to_i
    max_reds = reds if reds > max_reds
    max_blues = blues if blues > max_blues
    max_greens = greens if greens > max_greens
  end
  puts "Game #{game_index} power: #{max_reds * max_blues * max_greens}"
  game_power_sum += max_reds * max_blues * max_greens
end; 0

puts "Total sum of game power: #{game_power_sum}"
