def test_day02_rock_paper_scissors_points(_args, assert)
  assert.equal! Day02::RockPaperScissorsMatch.points(:rock, :rock), [4, 4]
  assert.equal! Day02::RockPaperScissorsMatch.points(:rock, :paper), [1, 8]
  assert.equal! Day02::RockPaperScissorsMatch.points(:rock, :scissors), [7, 3]
  assert.equal! Day02::RockPaperScissorsMatch.points(:paper, :rock), [8, 1]
  assert.equal! Day02::RockPaperScissorsMatch.points(:paper, :paper), [5, 5]
  assert.equal! Day02::RockPaperScissorsMatch.points(:paper, :scissors), [2, 9]
  assert.equal! Day02::RockPaperScissorsMatch.points(:scissors, :rock), [3, 7]
  assert.equal! Day02::RockPaperScissorsMatch.points(:scissors, :paper), [9, 2]
  assert.equal! Day02::RockPaperScissorsMatch.points(:scissors, :scissors), [6, 6]
end

def test_day02_rock_paper_scissors_match(_args, assert)
  match = Day02::RockPaperScissorsMatch.new

  match.play_round :rock, :paper

  assert.equal! match.scores, [1, 8]

  match.play_round :paper, :rock

  assert.equal! match.scores, [9, 9]

  match.play_round :scissors, :scissors

  assert.equal! match.scores, [15, 15]
end

def test_day02_rock_paper_scissors_play_rounds(_args, assert)
  match = Day02::RockPaperScissorsMatch.new
  rounds = Day02.parse_input(
    day02_test_input, my_symbol_meanings: {
      'X' => :rock,
      'Y' => :paper,
      'Z' => :scissors
    }
  )

  match.play_rounds rounds

  assert.equal! match.scores, [15, 15]
end

def day02_test_input
  PuzzleInput.new(<<~INPUT)
    A Y
    B X
    C Z
  INPUT
end
