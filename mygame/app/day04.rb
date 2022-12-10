class Day04
  class CleaningAssignment
    class << self
      def parse_assignment_pairs(input)
        input.lines.map { |line|
          line.split(',').map { |assignment_string|
            parse(assignment_string)
          }
        }
      end

      def parse(string)
        start_section, end_section = string.split('-').map(&:to_i)
        new(start_section, end_section)
      end

      def redundant_pairs(assignment_pairs)
        assignment_pairs.select { |assignment_pair|
          assignment_pair[0].completely_contains?(assignment_pair[1]) ||
            assignment_pair[1].completely_contains?(assignment_pair[0])
        }
      end
    end

    attr_reader :start_section, :end_section

    def initialize(start_section, end_section)
      @start_section = start_section
      @end_section = end_section
    end

    def completely_contains?(other)
      @start_section <= other.start_section && @end_section >= other.end_section
    end
  end

  def initialize
    @input = PuzzleInput.read('04')
  end

  def setup(args)
    state = args.state.day04 = args.state.new_entity(:day_state)
  end

  def tick(args)
    state = args.state.day03
    render(args.outputs, state)
    process_inputs(args.inputs, state)
    update(state)
  end

  def render(gtk_outputs, state)
  end

  def process_inputs(gtk_inputs, state)
  end

  def update(state)
  end
end

MapScreen.register Day04, day: 4, title: 'Camp Cleanup', x: 1000, y: 350
