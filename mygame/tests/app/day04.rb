def test_day04_cleaning_assignment_completely_contains(_args, assert)
  assignment1 = Day04::CleaningAssignment.new(1, 6)
  assignment2 = Day04::CleaningAssignment.new(2, 4)

  assert.true! assignment1.completely_contains?(assignment2)
end
