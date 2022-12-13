class String
  ALPHA = ('a'..'z').to_a

  def to_i52
    return 1 if self == 'S'
    return 27 if self == 'E'

    (0..length - 1).map do |i|
      ALPHA.index(self[i]) + 1 if ALPHA.include?(self[i])
    end.sum
  end
end

data = if ARGV.empty?
         DATA.readlines(chomp: true)
       else
         File.readlines(ARGV[0], chomp: true)
       end

@distances = {}
@neighbors = []
grid = data.map(&:chars)
@heights = Array.new(grid.size) { Array.new(grid.first.size) }
data.each.with_index do |line, x|
  line.chars.each.with_index do |char, y|
    @heights[x][y] = char.to_i52
    if ['a', 'S'].include?(char)
      @distances[[x, y]] = 0
      @neighbors << [x, y]
    end
    @finish_point = [x, y] if char == 'E'
  end
end

until @neighbors.empty?
  x, y = @neighbors.shift
  distance = @distances[[x, y]]
  [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
    nx = x + dx
    ny = y + dy
    next unless nx.between?(0, @heights.size - 1) && ny.between?(0, @heights.first.size - 1) &&
                @heights[nx][ny] <= @heights[x][y] + 1 &&
                (@distances[[nx, ny]].nil? || @distances[[nx, ny]] > distance + 1)

    @neighbors << [nx, ny]
    @distances[[nx, ny]] = distance + 1
  end
end
p @distances[@finish_point]

# 1129 # too high
# 1038 # too high
# 423 # just right

__END__
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
