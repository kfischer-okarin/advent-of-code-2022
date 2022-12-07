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

def test_day02_rock_paper_scissors_strategies_play_rock(_args, assert)
  [
    { when: :rock, then: :rock },
    { when: :paper, then: :rock },
    { when: :scissors, then: :rock }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_rock(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_rock_paper_scissors_strategies_play_paper(_args, assert)
  [
    { when: :rock, then: :paper },
    { when: :paper, then: :paper },
    { when: :scissors, then: :paper }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_paper(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_rock_paper_scissors_strategies_play_scissors(_args, assert)
  [
    { when: :rock, then: :scissors },
    { when: :paper, then: :scissors },
    { when: :scissors, then: :scissors }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_scissors(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_rock_paper_scissors_strategies_play_to_win(_args, assert)
  [
    { when: :rock, then: :paper },
    { when: :paper, then: :scissors },
    { when: :scissors, then: :rock }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_to_win(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_rock_paper_scissors_strategies_play_to_lose(_args, assert)
  [
    { when: :rock, then: :scissors },
    { when: :paper, then: :rock },
    { when: :scissors, then: :paper }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_to_lose(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_rock_paper_scissors_strategies_play_same(_args, assert)
  [
    { when: :rock, then: :rock },
    { when: :paper, then: :paper },
    { when: :scissors, then: :scissors }
  ].each do |test_case|
    assert.equal! Day02::Strategy.play_same(test_case[:when]),
                  test_case[:then],
                  "Expected to have played #{test_case[:then]} against #{test_case[:when]}"
  end
end

def test_day02_strategy_guide_rounds_to_play(_args, assert)
  guide = Day02::StrategyGuide.from_input(
    day02_test_input,
    strategies: {
      'X' => :play_rock,
      'Y' => :play_paper,
      'Z' => :play_scissors
    }
  )

  assert.equal! guide.rounds_to_play, [
    %i[paper rock],
    %i[rock paper],
    %i[scissors scissors]
  ]
end

def test_day02_rock_paper_scissors_play_rounds_part_1(_args, assert)
  match = Day02::RockPaperScissorsMatch.new
  guide = Day02::StrategyGuide.from_input(
    day02_test_input,
    strategies: {
      'X' => :play_rock,
      'Y' => :play_paper,
      'Z' => :play_scissors
    }
  )

  match.play_rounds guide.rounds_to_play

  assert.equal! match.scores, [15, 15]
end

def test_day02_rock_paper_scissors_play_rounds_part_2(_args, assert)
  match = Day02::RockPaperScissorsMatch.new
  guide = Day02::StrategyGuide.from_input(
    day02_test_input,
    strategies: {
      'X' => :play_to_lose,
      'Y' => :play_same,
      'Z' => :play_to_win
    }
  )

  match.play_rounds guide.rounds_to_play

  assert.equal! match.scores, [12, 15]
end

def day02_test_input
  PuzzleInput.new(<<~INPUT)
    A Y
    B X
    C Z
  INPUT
end
