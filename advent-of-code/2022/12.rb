class String
  ALPHA = ('a'..'z').to_a + ('A'..'Z').to_a

  def to_i52
    (0..length - 1).map do |i|
      ALPHA.index(self[i]) + 1 if ALPHA.include?(self[i])
    end.sum
  end
end

class Map
  START = 'S'.freeze
  FINISH = 'E'.freeze
  DIRECTIONS = %i[up right down left].freeze
  attr_reader :history, :map_arr

  def initialize
    # file_name = '12.input.txt'
    file_name = '12.test.txt'
    file = File.expand_path(file_name)
    lines = File.read(file).split("\n")
    @map_arr = lines.map.with_index(0) do |line, y|
      line.chars.map.with_index(0) do |char, x|
        { char: char, available_directions: %i[up right down left], y: y, x: x,
          visited_directions: [] }
      end
    end
    @history = []
    @failed_history = []
  end

  def calculate_possible_paths
    @history.push(starting_point)
    navigate
  end

  def starting_point
    if @starting_point.nil?
      @starting_point = @map_arr.flatten.select { |cell| cell[:char] == START }.first
      puts "Starting Point: #{@starting_point}"
    end
    @starting_point
  end

  def finish_point
    if @finish_point.nil?
      @finish_point = @map_arr.flatten.select { |cell| cell[:char] == FINISH }.first
      puts "Finish Point: #{@finish_point}"
    end
    @finish_point
  end

  def current_point
    @history.last
  end

  def directions_from_point(point)
    directions = point[:available_directions].select do |direction|
      move_doable?(direction, point, go_from_point(direction))
    end.compact
    optimal_direction = direction_of_finish_point
    if !optimal_direction.nil? && directions.include?(optimal_direction)
      puts "Put direction #{optimal_direction} on top."
      directions.delete(optimal_direction)
      directions.prepend(optimal_direction)
    end

    directions
  end

  def go_from_point(direction, commit: false)
    # puts "Go from #{point} to #{direction}"
    new_point = case direction
                when :up
                  up_from_point
                when :down
                  down_from_point
                when :left
                  left_from_point
                when :right
                  right_from_point
                end

    @history.push(new_point) if commit
    new_point
  end

  def simulate_paths
    @history.each do |point|
      print_state(point)
    end
  end

  def print_state(point = current_point)
    @map_arr.each do |row|
      row.each do |cell|
        cell_act = if point[:y] == cell[:y] && point[:x] == cell[:x]
                     '.'
                   else
                     cell[:char]
                   end
        print "#{cell_act} "
      end
      puts
    end
    puts
    gets
    nil
  end

  private

  def navigate
    print_state
    directions_from_point(current_point).map do |direction|
      go_from_point(direction, commit: true)
      return true if current_point == finish_point

      begin
        return true if navigate
      rescue StandardError
        return false
      end
      go_back_from_point
    end

    false
  end

  def move_doable?(direction, point_a, point_b)
    return false if point_b.nil? || point_a.nil? || direction.nil?
    return false if @history.include?(point_b)
    return false if @failed_history.include?(point_b)
    return true if point_a[:char] == START && point_b[:char] == 'a'
    return true if point_a[:char] == 'z' && point_b[:char] == FINISH
    return true if (0..1).include?(point_b[:char].to_i52 - point_a[:char].to_i52)

    false
  end

  def go_back_from_point
    @failed_history.push(@history.pop)
  end

  def up_from_point
    return @map_arr[current_point[:y] - 1][current_point[:x]] if current_point[:y].positive?

    nil
  end

  def down_from_point
    if current_point[:y] < @map_arr.count - 1
      return @map_arr[current_point[:y] + 1][current_point[:x]]
    end

    nil
  end

  def left_from_point
    return @map_arr[current_point[:y]][current_point[:x] - 1] if current_point[:x].positive?

    nil
  end

  def right_from_point
    if current_point[:x] < @map_arr.first.count - 1
      return @map_arr[current_point[:y]][current_point[:x] + 1]
    end

    nil
  end

  def direction_of_finish_point(point = current_point)
    diff_x = point[:x] - finish_point[:x]
    diff_y = point[:y] - finish_point[:y]

    if (diff_x.abs > diff_y.abs) && @previous_move == :vertical
      @previous_move = :horizontal
      if diff_x.positive?
        :left
      else
        :right
      end
    elsif diff_y.positive?
      @previous_move = :vertical
      :up
    else
      @previous_move = :vertical
      :down
    end
  end
end

map = Map.new
# finish_point = map.finish_point
# current_point = map.starting_point
# dirs = map.directions_from_point(current_point)
# direction = dirs.first

# current_point = map.go_from_point(direction, current_point, commit: true)
# dirs = map.directions_from_point(current_point)
# direction = dirs.first

# # current_point = go_from_point(direction, current_point, commit: true)
paths = map.calculate_possible_paths
puts "Possible Paths: #{paths}"
puts "Count: #{paths.count}"
# map.simulate_paths
# 1129 # too high
# 1038 # too high
