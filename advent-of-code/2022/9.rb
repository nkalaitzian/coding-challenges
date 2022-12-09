file_name = '9.test.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")

class RopeMovement
  attr_accessor :head_position, :tail_position, :head_movements, :tail_movements

  def initialize(head_position, tail_position)
    @head_position = head_position
    @tail_position = tail_position
    @head_movements = 0
    @tail_movements = 0
  end

  def move_head(direction, steps)
    steps.times.each do
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
    end
  end

  private

  def move_up
    @head_position = {y: head_position[:y] - 1, x: head_position[:x] }
    move_tail
  end

  def should_move_tail?
    
  end

  def move_tail
    return unless should_move_tail?
  end
end