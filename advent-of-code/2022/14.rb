require 'curses'

include Curses
class Cave
  attr_reader :rock_lines, :sand_coords, :rocks

  def initialize(input = nil)
    data = if !defined?(DATA) && input.nil?
             '498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9'.split("\n")
           elsif ARGV.empty? && defined?(DATA)
             DATA.readlines(chomp: true)
           elsif ARGV[0] == 'input' || input
             File.readlines('14.input.txt', chomp: true)
           end
    init_window if ARGV[1] != 'false'
    @rock_lines = []
    @sand_coords = {}
    @min_y = 0
    @win << "Building cave\n" if @win
    @win.refresh if @win
    data.each do |line|
      rock_line = []
      line.split(' -> ').each.with_index do |coord, i|
        x, y = coord.split(',').map(&:to_i)
        rock_line[i] = { x: x, y: y }
        @min_x = x if @min_x.nil? || x < @min_x
        @min_y = y if @min_y.nil? || y < @min_y
        @max_x = x if @max_x.nil? || x > @max_x
        @max_y = y if @max_y.nil? || y > @max_y
      end
      @rock_lines << rock_line
      @rocks = {}
    end
  end

  def start
    visualize_cave(true)
    @i = 0
    @win.getch if @win
    begin
      previous_vis = cave_vis
      throw_sand
      @i += 1
      puts @i if (@i % 50).zero? && !@win
      visualize_cave(true) if @win || (@i % 500).zero?
    end until previous_vis == cave_vis
    if @win
      @win << "Done!\n"
      @win.refresh
      @win.getch
    else
      visualize_cave(true)
      puts "#{cave_vis.flatten.select { |dot| dot == 'o' }.count} sand particles"
    end
  ensure
    close_screen if @win
  end

  def start2
    @min_x -= (@max_y - @min_y)
    @max_x += (@max_y - @min_y)
    @max_y += 2
    init_rocks
    (@min_x..@max_x).each do |x|
      @rocks[[@max_y, x]] = '#'
    end
    start
  end

  def throw_sand
    @sand = { x: 500, y: 0 }
    begin
      previous_coords = @sand
      @sand = calculate_new_sand_coordinates(@sand[:y], @sand[:x])
      visualize_cave(@rock_lines.size < 50)
      sleep(0.01) if @rock_lines.size < 50
    end until @sand.nil? || previous_coords == @sand
    save_sand(@sand[:y], @sand[:x]) unless @sand.nil?
  end

  def calculate_new_sand_coordinates(y, x)
    # puts "Calculating new coordinates for y:#{y}, x:#{x}"

    return unless (@min_y..@max_y).include?(y) && (@min_x..@max_x).include?(x)
    return { y: y + 1, x: x } unless ['#', 'o'].include?(material_at_coords(y + 1, x)) # down
    return { y: y + 1, x: x - 1 } unless ['#', 'o'].include?(material_at_coords(y + 1, x - 1)) # left-down diagonal
    return { y: y + 1, x: x + 1 } unless ['#', 'o'].include?(material_at_coords(y + 1, x + 1)) # right-down diagonal

    { y: y, x: x }
  end

  def visualize_cave(print = false)
    return cave_vis unless print

    @win.setpos(0, 0) if @win
    @win << "Sand particles so far: #{@i}\n" if @i && @win

    cave_vis.each do |row|
      if @win
        @win << (row.join + "\n")
      else
        puts row.join
      end
    end
    @win.refresh if @win
    nil
  end

  def cave_vis
    (@min_y..@max_y).map do |y|
      (@min_x..@max_x).map do |x|
        material_at_coords(y, x)
      end
    end
  end

  def material_at_coords(y, x)
    init_rocks if @rocks.empty?
    return @rocks[[y, x]] if @rocks[[y, x]]

    @sand_coords[[y, x]] || (@sand && @sand[:y] == y && @sand[:x] == x ? 'o' : nil) || '.'
  end

  private

  def init_rocks
    @rock_lines.each do |rock_lines|
      (0..rock_lines.length - 2).each do |i|
        starting_point = rock_lines[i]
        end_point = rock_lines[i + 1]

        xs = [starting_point[:x], end_point[:x]]
        ys = [starting_point[:y], end_point[:y]]

        (ys.min..ys.max).each do |y|
          (xs.min..xs.max).each do |x|
            @rocks[[y, x]] = '#'
          end
        end
      end
    end
  end

  def save_sand(y, x)
    return unless (@min_y..@max_y).include?(y) && (@min_x..@max_x).include?(x)

    @sand_coords[[y, x]] = 'o'
  end

  def init_window
    init_screen
    start_color
    curs_set(0)
    noecho

    init_pair(1, 1, 0)
    @win = Curses::Window.new(0, 0, 0, 0)
  end
end

cave = Cave.new('a')
# cave.start
# 1406

cave.start2
__END__
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
