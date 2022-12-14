def test_day04_cleaning_assignment_completely_contains(_args, assert)
  assert.true! Day04::CleaningAssignment.new(1, 6).completely_contains?(Day04::CleaningAssignment.new(2, 4))
end

def test_day04_cleaning_assignment_overlaps(_args, assert)

  assert.true! Day04::CleaningAssignment.new(1, 6).overlaps?(Day04::CleaningAssignment.new(5, 9))
  assert.true! Day04::CleaningAssignment.new(5, 9).overlaps?(Day04::CleaningAssignment.new(5, 9))
  assert.true! Day04::CleaningAssignment.new(1, 6).overlaps?(Day04::CleaningAssignment.new(2, 4))
  assert.true! Day04::CleaningAssignment.new(2, 4).overlaps?(Day04::CleaningAssignment.new(1, 6))
  assert.false! Day04::CleaningAssignment.new(1, 6).overlaps?(Day04::CleaningAssignment.new(7, 9))
end

def test_day04_part1(_args, assert)
  assignment_pairs = Day04::CleaningAssignment.parse_assignment_pairs(day04_test_input)

  redundant_pairs = Day04::CleaningAssignment.redundant_pairs(assignment_pairs)

  assert.equal! redundant_pairs.length, 2
end

def test_day04_part2(_args, assert)
  assignment_pairs = Day04::CleaningAssignment.parse_assignment_pairs(day04_test_input)

  overlapping_pairs = Day04::CleaningAssignment.overlapping_pairs(assignment_pairs)

  assert.equal! overlapping_pairs.length, 4
end

def day04_test_input
  PuzzleInput.new(<<~INPUT)
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  INPUT
end
