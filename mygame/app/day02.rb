class Day02
  ENEMY_SYMBOL_MEANINGS = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors
  }.freeze

  class << self
    def parse_input(puzzle_input, my_symbol_meanings:)
      puzzle_input.lines.map { |line|
        enemy_choice, my_choice = line.split
        [
          ENEMY_SYMBOL_MEANINGS[enemy_choice],
          my_symbol_meanings[my_choice]
        ]
      }
    end
  end

  class RockPaperScissorsMatch
    SHAPE_POINTS = {
      rock: 1,
      paper: 2,
      scissors: 3
    }.freeze

    class << self
      def points(choice1, choice2)
        points1, points2 = match_points(choice1, choice2)
        [
          points1 + SHAPE_POINTS[choice1],
          points2 + SHAPE_POINTS[choice2]
        ]
      end

      def match_points(choice1, choice2)
        return [3, 3] if choice1 == choice2

        case [choice1, choice2]
        when %i[rock scissors], %i[paper rock], %i[scissors paper]
          [6, 0]
        else
          [0, 6]
        end
      end
    end

    attr_reader :scores

    def initialize
      @scores = [0, 0]
    end

    def play_rounds(rounds)
      rounds.each { |round| play_round(*round) }
    end

    def play_round(choice1, choice2)
      points1, points2 = self.class.points(choice1, choice2)
      @scores[0] += points1
      @scores[1] += points2
    end
  end

  def initialize
    @input = PuzzleInput.read('02')
    match = RockPaperScissorsMatch.new
    match.play_rounds(Day02.parse_input(@input, my_symbol_meanings: {
      'X' => :rock,
      'Y' => :paper,
      'Z' => :scissors
    }))
    puts match.scores
  end

  def tick(args)
    state = args.state.day02
  end
end

MapScreen.register Day02, day: 2, title: 'Rock Paper Scissors', x: 1100, y: 220
