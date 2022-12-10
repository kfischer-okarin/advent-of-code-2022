class Day04
  class CleaningAssignment
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
