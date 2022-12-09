class Day02
  ENEMY_SYMBOL_MEANINGS = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors
  }.freeze

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

  class StrategyGuide
    class << self
      def from_input(puzzle_input, strategies:)
        rounds_to_play = puzzle_input.lines.map { |line|
          enemy_choice_symbol, my_choice_symbol = line.split
          enemy_choice = ENEMY_SYMBOL_MEANINGS[enemy_choice_symbol]
          [
            Strategy.send(strategies[my_choice_symbol], enemy_choice),
            enemy_choice
          ]
        }
        new(rounds_to_play)
      end
    end

    attr_reader :rounds_to_play

    def initialize(rounds_to_play)
      @rounds_to_play = rounds_to_play
      @round_index = 0
    end

    def play_next_round(match)
      round = @rounds_to_play[@round_index]
      if round
        match.play_round(*round)
        @round_index += 1
      end
      round
    end
  end

  module Strategy
    class << self
      def play_rock(_enemy_choice)
        :rock
      end

      def play_paper(_enemy_choice)
        :paper
      end

      def play_scissors(_enemy_choice)
        :scissors
      end

      def play_to_win(enemy_choice)
        case enemy_choice
        when :rock
          :paper
        when :paper
          :scissors
        when :scissors
          :rock
        end
      end

      def play_to_lose(enemy_choice)
        case enemy_choice
        when :rock
          :scissors
        when :paper
          :rock
        when :scissors
          :paper
        end
      end

      def play_same(enemy_choice)
        enemy_choice
      end
    end
  end

  def initialize
    @input = PuzzleInput.read('02')
  end

  def setup(args)
    state = args.state.day02 = {}
    options = [
      { label: 'Play Rock', value: :play_rock },
      { label: 'Play Paper', value: :play_paper },
      { label: 'Play Scissors', value: :play_scissors },
      { label: 'Play to Win', value: :play_to_win },
      { label: 'Play to Lose', value: :play_to_lose },
      { label: 'Play Same', value: :play_same }
    ]
    state.x_strategy = DropdownSelect.build(
      x: 550, y: 580, w: 200, options: options, selected: :play_rock
    )
    state.y_strategy = DropdownSelect.build(
      x: 550, y: 530, w: 200, options: options, selected: :play_paper
    )
    state.z_strategy = DropdownSelect.build(
      x: 550, y: 480, w: 200, options: options, selected: :play_scissors
    )
    state.button_rect = { x: 570, y: 380, w: 120, h: 75 }
  end

  def tick(args)
    state = args.state.day02
    render(args.outputs, state)
    process_inputs(args.inputs, state)
    update(state)
  end

  def render(outputs, state)
    render_my_elf(outputs, state.last_played_round&.first || :rock)
    render_enemy_elf(outputs, state.last_played_round&.second || :rock)
    render_ui(outputs, state)
  end

  def render_my_elf(outputs, choice)
    render_scaled_sprite(
      outputs,
      x: 320, y: 0, path: 'sprites/rps-cast.png',
      source_x: (8 * 64) + 32, source_y: 20 + CHOICE_Y[choice], source_w: 32, source_h: 36,
      scale: 10
    )
    render_scaled_sprite(
      outputs,
      x: 0, y: 0, path: 'sprites/elf-female.png',
      source_x: 256, source_y: 340, source_w: 49, source_h: 36,
      scale: 10
    )
    render_scaled_sprite(
      outputs,
      x: 0, y: 0, path: 'sprites/elf-female.png',
      source_x: 256, source_y: 340, source_w: 51, source_h: 10,
      scale: 10
    )
  end

  def render_enemy_elf(outputs, choice)
    render_scaled_sprite(
      outputs,
      x: 640, y: 0, path: 'sprites/rps-cast.png',
      source_x: 0, source_y: 20 + 3 * 64 + CHOICE_Y[choice], source_w: 64, source_h: 36,
      scale: 10
    )
    render_scaled_sprite(
      outputs,
      x: 780, y: 0, path: 'sprites/elf-male.png',
      source_x: 270, source_y: 468, source_w: 49, source_h: 36,
      scale: 10
    )
    render_scaled_sprite(
      outputs,
      x: 640, y: 0, path: 'sprites/elf-male.png',
      source_x: 256, source_y: 468, source_w: 51, source_h: 10,
      scale: 10
    )
  end

  CHOICE_Y = {
    rock: 128,
    paper: 64,
    scissors: 0
  }.freeze

  def render_ui(gtk_outputs, state)
    UI.draw_panel(gtk_outputs, x: 480, y: 400, w: 300, h: 300)
    gtk_outputs.primitives << { x: 520, y: 660, text: 'Strategies:', size_enum: 5 }
    gtk_outputs.primitives << { x: 520, y: 660, text: 'Strategies:', size_enum: 5 }
    gtk_outputs.primitives << { x: 520, y: 610, text: 'X:', size_enum: 3 }
    gtk_outputs.primitives << { x: 520, y: 560, text: 'Y:', size_enum: 3 }
    gtk_outputs.primitives << { x: 520, y: 510, text: 'Z:', size_enum: 3 }
    DropdownSelect.render_select(gtk_outputs, state.x_strategy)
    DropdownSelect.render_select(gtk_outputs, state.y_strategy)
    DropdownSelect.render_select(gtk_outputs, state.z_strategy)
    render_play_button(gtk_outputs, state) unless @playing
    render_scores(gtk_outputs) if @match
    DropdownSelect.render_popup(gtk_outputs, state.x_strategy)
    DropdownSelect.render_popup(gtk_outputs, state.y_strategy)
    DropdownSelect.render_popup(gtk_outputs, state.z_strategy)
  end

  def render_play_button(gtk_outputs, state)
    UI.draw_button(gtk_outputs, **state.button_rect)
    gtk_outputs.primitives << {
      x: 630, y: 418, text: 'Play',
      size_enum: 3, alignment_enum: 1, vertical_alignment_enum: 1,
      r: 255, g: 255, b: 255
    }.label!
  end

  def render_scores(gtk_outputs)
    my_score, enemy_score = @match.scores
    gtk_outputs.primitives << {
      x: 630, y: 350, text: "#{my_score}     #{enemy_score}",
      size_enum: 3, alignment_enum: 1, vertical_alignment_enum: 1
    }.label!
  end

  def render_scaled_sprite(gtk_outputs, x:, y:, path:, source_x:, source_y:, source_w:, source_h:, scale:)
    gtk_outputs.primitives << {
      x: x, y: y, w: source_w * scale, h: source_h * scale, path: path,
      source_x: source_x, source_y: source_y, source_w: source_w, source_h: source_h
    }.sprite!
  end

  def process_inputs(gtk_inputs, state)
    return if @playing

    return if DropdownSelect.process_inputs!(gtk_inputs, state.x_strategy)
    return if DropdownSelect.process_inputs!(gtk_inputs, state.y_strategy)
    return if DropdownSelect.process_inputs!(gtk_inputs, state.z_strategy)

    handle_play_button(gtk_inputs, state)
  end

  def handle_play_button(gtk_inputs, state)
    mouse = gtk_inputs.mouse
    return unless mouse.click && mouse.inside_rect?(state.button_rect)

    @match = RockPaperScissorsMatch.new
    @guide = StrategyGuide.from_input(
      @input,
      strategies: {
        'X' => DropdownSelect.selected_value(state.x_strategy),
        'Y' => DropdownSelect.selected_value(state.y_strategy),
        'Z' => DropdownSelect.selected_value(state.z_strategy)
      }
    )
    @playing = true
  end

  def update(state)
    handle_play(state) if @playing
  end

  def handle_play(state)
    last_played_round = nil
    10.times do
      last_played_round = @guide.play_next_round @match
    end

    if last_played_round
      state.last_played_round = last_played_round
    else
      @playing = false
    end
  end
end

MapScreen.register Day02, day: 2, title: 'Rock Paper Scissors', x: 1100, y: 220
