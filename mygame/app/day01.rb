class Day01
  def initialize
    @input = PuzzleInput.read('01')
  end

  def setup(args)
    args.state.day01.state.animations = {}
    state = args.state.day01
    state.animations[:idle_up] = build_idle_animation(512)
    state.animations[:idle_left] = build_idle_animation(576)
    state.animations[:idle_down] = build_idle_animation(640)
    state.animations[:idle_right] = build_idle_animation(706)
    state.animations[:walk_up] = build_walk_animation(512)
    state.animations[:walk_left] = build_walk_animation(576)
    state.animations[:walk_down] = build_walk_animation(640)
    state.animations[:walk_right] = build_walk_animation(706)

    state.elves = 100.times.map {
      build_elf(state, x: rand * (1280 - 64), y: rand * (720 - 64))
    }
  end

  def build_elf(state, x:, y:)
    {
      x: x,
      y: y,
      state: {
        type: %i[idle walk].sample,
        direction: %i[up left down right].sample,
        remaining_ticks: (rand * 300).ceil
      },
      sprite: AnimatedSprite.build(
        path: "sprites/elf-#{%i[male female].sample}.png",
        animations: state.animations
      ),
    }
  end

  def build_idle_animation(tile_y)
    Animations.build(
      w: 64, h: 64, tile_w: 64, tile_h: 64,
      frames: [
        { tile_x: 0, tile_y: tile_y, duration: 1 }
      ]
    )
  end

  def build_walk_animation(tile_y, duration: 8)
    Animations.build(
      w: 64, h: 64, tile_w: 64, tile_h: 64,
      frames: (0..7).map { |i|
        { tile_x: 64 + (64 * i), tile_y: tile_y, duration: duration }
      }
    )
  end

  def tick(args)
    state = args.state.day01
    render(args.outputs, state)
    update(state)
  end

  def render(gtk_outputs, state)
    gtk_outputs.primitives << {
      x: 0, y: 0, w: 1280, h: 720, path: 'maps/day01/png/Level_0.png'
    }.sprite!
    state.elves.each do |elf|
      elf[:sprite].update x: elf[:x] - 32, y: elf[:y]
      AnimatedSprite.update! elf[:sprite], animation: :"#{elf[:state][:type]}_#{elf[:state][:direction]}"
      gtk_outputs.primitives << elf[:sprite]
      gtk_outputs.primitives << { x: elf[:x] - 16, y: elf[:y], w: 32, h: 64, r: 255, g: 0, b: 0 }.border!
    end
  end

  def update(state)
    state.elves.each do |elf|
      elf_state = elf[:state]
      if elf_state[:remaining_ticks].positive?
        elf_state[:remaining_ticks] -= 1
      else
        elf_state[:remaining_ticks] = (rand * 300).ceil
        elf_state[:type] = elf_state[:type] == :idle ? :walk : :idle
        elf_state[:direction] = %i[up left down right].sample if elf_state[:type] == :walk
      end
      next unless elf_state[:type] == :walk

      case elf_state[:direction]
      when :up
        elf[:y] = [elf[:y] + 1, 720 - 64].min
      when :left
        elf[:x] = [elf[:x] - 1, 16].max
      when :down
        elf[:y] = [elf[:y] - 1, 0].max
      when :right
        elf[:x] = [elf[:x] + 1, 1280 - 16].min
      end
    end
  end
end

MapScreen.register Day01, day: 1, title: 'Calorie Counting', x: 70, y: 230
