def test_day01_inventories(_args, assert)
  puzzle_input = day01_test_input

  inventories = Day01.parse_input puzzle_input

  assert.equal! inventories.length, 5
  assert.equal! inventories[0].items, [1000, 2000, 3000]
end

def test_day01_max_total_calories(_args, assert)
  puzzle_input = day01_test_input
  inventories = Day01.parse_input puzzle_input

  assert.equal! inventories.max_total_calories, 24_000
end

def day01_test_input
  PuzzleInput.new(<<~INPUT)
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
  INPUT
end
