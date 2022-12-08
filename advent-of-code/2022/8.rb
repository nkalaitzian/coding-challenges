file_name = '8.input.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")

@trees = file_contents.map { |fc| fc.chars.map(&:to_i) }

def visible_from_up?(tree, y, x)
  return true if y.zero?

  @trees[0..y - 1].map { |row| row[x] }.flatten.none? { |ot| ot >= tree }
end

def visible_from_down?(tree, y, x)
  return true if y == @trees.count

  @trees[y + 1..].map { |row| row[x] }.flatten.none? { |ot| ot >= tree }
end

def visible_from_left?(tree, y, x)
  return true if x.zero?

  @trees[y][..x - 1].flatten.none? { |ot| ot >= tree }
end

def visible_from_right?(tree, y, x)
  return true if x == @trees.count

  @trees[y][x + 1..].flatten.none? { |ot| ot >= tree }
end

def visible?(tree, y, x)
  return true if y == 0 || x == 0 || y == 99 || x == 99

  visible_from_up?(tree, y, x) ||
    visible_from_down?(tree, y, x) ||
    visible_from_left?(tree, y, x) ||
    visible_from_right?(tree, y, x)
end

visible_trees = []
@trees.each.with_index(0) do |tree_line, y|
  tree_line.each.with_index(0) do |tree, x|
    visible_trees << { tree: tree, y: y, x: x } if visible?(tree, y, x)
  end
end

puts "A total of #{visible_trees.count} are visible."
# A total of 3331 are visible. # Too high.
# A total of 1103 are visible. # Incorrect
# A total of 1295 are visible. # Incorrect
# A total of 1798 are visible. # Great success
# visible_trees.reject { |t| [0, 99].include?(t[:x]) || [0, 99].include?(t[:y]) }

# =======================================================

file_name = '8.input.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")

@trees = file_contents.map { |fc| fc.chars.map(&:to_i) }

def score_up(tree, y, x)
  return 0 if [0, @trees.count].include?(x)
  return 0 if [0, @trees.count].include?(y)

  sum = 0
  counts = true
  @trees[...y].reverse.each do |t|
    sum += 1 if counts
    counts = false if tree <= t[x]
  end
  sum
end

def score_down(tree, y, x)
  return 0 if [0, @trees.count].include?(x)
  return 0 if [0, @trees.count].include?(y)

  sum = 0
  counts = true
  @trees[y+1..].each do |t|
    sum += 1 if counts
    counts = false if tree <= t[x]
  end
  sum
end

def score_left(tree, y, x)
  return 0 if [0, @trees.count].include?(x)
  return 0 if [0, @trees.count].include?(y)

  sum = 0
  counts = true
  @trees[y][0...x].reverse.each do |t|
    sum += 1 if counts
    counts = false if tree <= t
  end
  sum
end

def score_right(tree, y, x)
  return 0 if [0, @trees.count].include?(x)
  return 0 if [0, @trees.count].include?(y)

  sum = 0
  counts = true
  @trees[y][x + 1..].each do |t|
    sum += 1 if counts
    counts = false if tree <= t
  end
  sum
end

def scenic_score(tree, y, x)
  score_up(tree, y, x) *
    score_down(tree, y, x) *
    score_left(tree, y, x) *
    score_right(tree, y, x)
end

tree_scores = []
@trees.each.with_index(0) do |tree_line, y|
  tree_line.each.with_index(0) do |tree, x|
    tree_scores << { tree: tree, y: y, x: x, score: scenic_score(tree, y, x) }
  end
end
tree_scores.max_by { |ts| ts[:score] }
# => {:tree=>7, :y=>42, :x=>19, :score=>31600} # too low
# => {:tree=>7, :y=>52, :x=>14, :score=>2812992} # too high
# => {:tree=>7, :y=>86, :x=>49, :score=>259308} # correct
