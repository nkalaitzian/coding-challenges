file = "4.input.txt"
file_contents = File.open(file, "r").read
assignments = file_contents.split("\n").map { |line| line.split(",") }

overlaps = assignments.each.with_object([]) do |assignment, overlaps|
  first_ass = assignment.first.split("-")
  second_ass = assignment.last.split("-")

  first_range = (first_ass.first..first_ass.last).to_a
  second_range = (second_ass.first..second_ass.last).to_a

  overlap = (first_range & second_range)

  overlaps << overlap if overlap == first_range || overlap == second_range
end.compact

overlaps.count
# => 526

total_overlaped_pairs = assignments.map do |assignment|
  first_ass = assignment.first.split("-")
  second_ass = assignment.last.split("-")

  first_range = (first_ass.first..first_ass.last).to_a
  second_range = (second_ass.first..second_ass.last).to_a

  overlap = (first_range & second_range)

  if overlap.any?
    1
  else
    0
  end
end.sum
# => 886
