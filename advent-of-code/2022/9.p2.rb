class RopeMovement
  attr_reader :parent, :idx
  attr_accessor :position, :child, :tail_positions

  START = { x: 20, y: 20 }

  def initialize(parent, idx)
    @position = { x: 20, y: 20 }
    @parent = parent
    @tail_positions = []
    @idx = idx
    return if parent.nil?

    parent.child = self
  end

  def move(direction, record: true, print: false, mc: true)
    # puts "Moving #{name} #{direction}"
    case direction
    when :up
      move_up
    when :down
      move_down
    when :left
      move_left
    when :right
      move_right
    end

    return if !mc
    move_child(mc: mc)
    print_pos if print
    @tail_positions << @position if record && tail?
  end

  def print_pos(coords: init_coords)
    coords[position[:y]][position[:x]] = name if coords[position[:y]][position[:x]] == '.'
    child&.print_pos(coords: coords)

    return unless name == 'H'

    coords[START[:y]][START[:x]] = 's' if coords[START[:y]][START[:x]] == '.'

    coords.each do |row|
      [row].flatten.each do |cell|
        print "#{cell} "
      end
      puts
    end
    puts
  end

  def positions(pos: [])
    pos << { name: name, x: position[:x], y: position[:y] }
    child&.positions(pos: pos)

    pos
  end

  def name
    if parent.nil?
      'H'
    elsif child.nil?
      'T'
    else
      @idx.to_s
    end
  end

  def tail
    if child.nil?
      self
    else
      child.tail
    end
  end

  def knots
    all_knots = []
    all_knots << self
    all_knots += child.knots if child

    all_knots
  end

  def knot_at(y, x)
    knots.select { |k| k[:y] == y && k[:x] == x }.first
  end

  def tail?
    child.nil?
  end

  def to_s
    "#{name}, x: #{position[:x]}, y: #{position[:y]}"
  end

  private

  def init_coords
    (1..40).map { ('.' * 40).chars }
  end

  def move_up
    @position = { y: position[:y] - 1, x: position[:x] }
  end

  def move_down
    @position = { y: position[:y] + 1, x: position[:x] }
  end

  def move_left
    @position = { y: position[:y], x: position[:x] - 1 }
  end

  def move_right
    @position = { y: position[:y], x: position[:x] + 1 }
  end

  def distance_x
    if child
      child.position[:x] - position[:x]
    else
      0
    end
  end

  def distance_y
    if child
      child.position[:y] - position[:y] unless child.nil?
    else
      0
    end
  end

  def should_move_child?
    return true if distance_x.abs > 1 || distance_y.abs > 1

    false
  end

  def move_child(mc: true)
    # puts "Moving child #{child.name}. Should? #{should_move_child?}. mc: #{mc}" if child
    return unless should_move_child?
    # return if !mc

    if (distance_x.abs > 1 && distance_y.abs >= 1) || (distance_y.abs > 1 && distance_x.abs >= 1)
      move_child_vertical(distance_y.positive? ? :up : :down, record: false, mc: false)
      move_child_horizontal(distance_x.positive? ? :left : :right, record: true, mc: mc)
    elsif distance_y.zero? && distance_x.abs > 1
      move_child_horizontal(distance_x.positive? ? :left : :right, record: true, mc: mc)
    elsif distance_x.zero? && distance_y.abs > 1
      move_child_vertical(distance_y.positive? ? :up : :down, record: true, mc: mc)
    end
  end

  def move_child_vertical(direction, record: true, mc: true)
    if direction == :up
      move_child_up(record: record, mc: mc)
    else
      move_child_down(record: record, mc: mc)
    end
  end

  def move_child_horizontal(direction, record: true, mc: true)
    if direction == :left
      move_child_left(record: record, mc: mc)
    else
      move_child_right(record: record, mc: mc)
    end
  end

  def move_child_up(record: true, mc: true)
    child.move(:up, record: record, mc: mc)
  end

  def move_child_down(record: true, mc: true)
    child.move(:down, record: record, mc: mc)
  end

  def move_child_left(record: true, mc: true)
    child.move(:left, record: record, mc: mc)
  end

  def move_child_right(record: true, mc: false)
    child.move(:right, record: record, mc: mc)
  end
end

def reset_head
  head = RopeMovement.new(nil, 0)
  current = head
  (1..9).each do |i|
    current = RopeMovement.new(current, i)
  end; nil

  head.tail.tail_positions = [head.tail.position]
  head
end

head = reset_head

# head.move(:right, print: true) # x5

# head.move(:up, print: true) # x8

# head.move(:left, print: true) # x8

# head.move(:down, print: true) # x3

# head.move(:right, print: true) # x17
# head.move(:down, print: true) # x10

file_name = '9.input.txt'
# file_name = '9.test.2.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")
# => ["R 5", "U 8", "L 8", "D 3", "R 17", "D 10", "L 25", "U 20"]

file_contents.each do |line|
  move, steps = case line
                when /R (\d)/
                  [:right, line.gsub(/\w\s/, '').to_i]
                when /L (\d)/
                  [:left, line.gsub(/\w\s/, '').to_i]
                when /U (\d)/
                  [:up, line.gsub(/\w\s/, '').to_i]
                when /D (\d)/
                  [:down, line.gsub(/\w\s/, '').to_i]
                end
  steps.times { head.move(move, print: false) }
end; nil

puts "Total unique tail positions: #{head.tail.tail_positions.uniq.size}"
# => Total unique tail positions: 2566
