@moves = [{ move: :rock, opponent: "A", me: "X", beats: :scissors, is_beat_by: :paper },
          { move: :paper, opponent: "B", me: "Y", beats: :rock, is_beat_by: :scissors },
          { move: :scissors, opponent: "C", me: "Z", beats: :paper, is_beat_by: :rock }]

@points = { moves: { rock: 1, paper: 2, scissors: 3 },
            conditions: { loss: 0, draw: 3, win: 6 } }
file_contents = File.open("2.input.txt", "r").read
total_moves = file_contents.
  split("\n").
  map { |moves| moves.split("\s") }.
  map { |moveset| { opponent: moveset.first, me: moveset.last } }

def calculate_move_score(move)
  # puts "#{move}"
  opponent_move = @moves.select { |params| params[:opponent] == move[:opponent] }.first
  my_move = @moves.select { |params| params[:me] == move[:me] }.first

  score = @points[:moves][my_move[:move]] + if my_move[:beats] == opponent_move[:move]
    @points[:conditions][:win]
  elsif my_move[:is_beat_by] == opponent_move[:move]
    @points[:conditions][:loss]
  else
    @points[:conditions][:draw]
  end
end

sum_of_move_scores = total_moves.map { |move| calculate_move_score(move) }.sum
puts "Total Score: #{sum_of_move_scores}"

# ========================= 2 ================================

@new_moves = [{ move: :rock, opponent: "A", loss: :paper, win: :scissors, draw: :rock },
              { move: :paper, opponent: "B", loss: :scissors, win: :rock, draw: :paper },
              { move: :scissors, opponent: "C", loss: :rock, win: :paper, draw: :scissors }]
@suggested_moves = { "X" => :loss, "Y" => :draw, "Z" => :win }

def new_calculate_move_score(move)
  my_move = move[:me]
  strategy = move[:strategy]

  move_points = @points[:moves][my_move[:move]]
  condition_points = @points[:conditions][strategy]
  move_points + condition_points
end

#
new_total_moves = file_contents.
  split("\n").
  map { |moves| moves.split("\s") }.
  map do |moveset|
  opponent = @new_moves.select { |move| moveset.first == move[:opponent] }.first
  strategy = @suggested_moves[moveset.last]
  me = @new_moves.select { |move| move[strategy] == opponent[:move] }.first
  { opponent: opponent, me: me, strategy: strategy, arr: moveset }
end
sum_of_move_scores = new_total_moves.map { |move| new_calculate_move_score(move) }.sum
puts "New Total Score: #{sum_of_move_scores}"
