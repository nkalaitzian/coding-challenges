file_name = '9.input.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")

class RopeMovement
  attr_accessor :head_position, :tail_position, :tail_positions
  alias head_location head_position
  alias tail_location tail_position

  def initialize
    @head_position = { x: 0, y: 0 }
    @tail_position = { x: 0, y: 0 }
    @tail_positions = [@tail_position]
  end

  def move_head(direction, steps)
    steps.times.each do
      case direction
      when :up
        move_head_up
      when :down
        move_head_down
      when :left
        move_head_left
      when :right
        move_head_right
      end
    end
    # positions
  end

  def positions
    puts "Head position: #{head_position}"
    puts "Tail position: #{tail_position}"
  end

  private

  def move_head_up
    @head_position = { y: head_position[:y] - 1, x: head_position[:x] }
    move_tail
  end

  def move_head_down
    @head_position = { y: head_position[:y] + 1, x: head_position[:x] }
    move_tail
  end

  def move_head_left
    @head_position = { y: head_position[:y], x: head_position[:x] - 1 }
    move_tail
  end

  def move_head_right
    @head_position = { y: head_position[:y], x: head_position[:x] + 1 }
    move_tail
  end

  def should_move_tail?
    return true if distance_x.abs > 1
    return true if distance_y.abs > 1

    false
  end

  def distance_x
    tail_position[:x] - head_position[:x]
  end

  def distance_y
    tail_position[:y] - head_position[:y]
  end

  def move_tail
    return unless should_move_tail?

    if (distance_x.abs > 1 && distance_y.abs == 1) || (distance_y.abs > 1 && distance_x.abs == 1)
      move_tail_vertical(distance_y.positive? ? :up : :down, record: false)
      move_tail_horizontal(distance_x.positive? ? :left : :right, record: true)
    elsif distance_x.abs > 1 && distance_y.zero?
      move_tail_horizontal(distance_x.positive? ? :left : :right, record: true)
    elsif distance_y.abs > 1 && distance_x.zero?
      move_tail_vertical(distance_y.positive? ? :up : :down, record: true)
    end
  end

  def move_tail_vertical(direction, record: true)
    if direction == :up
      move_tail_up(record: record)
    else
      move_tail_down(record: record)
    end
  end

  def move_tail_horizontal(direction, record: true)
    if direction == :left
      move_tail_left(record: record)
    else
      move_tail_right(record: record)
    end
  end

  def move_tail_up(record: true)
    @tail_position = { y: tail_position[:y] - 1, x: tail_position[:x] }
    @tail_positions << @tail_position if record
  end

  def move_tail_down(record: true)
    @tail_position = { y: tail_position[:y] + 1, x: tail_position[:x] }
    @tail_positions << @tail_position if record
  end

  def move_tail_left(record: true)
    @tail_position = { y: tail_position[:y], x: tail_position[:x] - 1 }
    @tail_positions << @tail_position if record
  end

  def move_tail_right(record: true)
    @tail_position = { y: tail_position[:y], x: tail_position[:x] + 1 }
    @tail_positions << @tail_position if record
  end
end

# rope = RopeMovement.new
# rope.move_head(:right, 4)
# rope.move_head(:down, 4)
# rope.move_head(:left, 3)
# rope.move_head(:up, 1)
# rope.move_head(:right, 4)
# rope.move_head(:up, 1)
# rope.move_head(:left, 5)
# rope.move_head(:right, 2)
# rope.tail_positions.uniq.size

rope = RopeMovement.new
file_contents.each do |line|
  case line
  when /R (\d)/
    rope.move_head(:right, line.gsub(/\w\s/, '').to_i)
  when /L (\d)/
    rope.move_head(:left, line.gsub(/\w\s/, '').to_i)
  when /U (\d)/
    rope.move_head(:up, line.gsub(/\w\s/, '').to_i)
  when /D (\d)/
    rope.move_head(:down, line.gsub(/\w\s/, '').to_i)
  end
end; nil

puts "Total unique tail positions: #{rope.tail_positions.uniq.size}"