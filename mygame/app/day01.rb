class Day01
  class << self
    def parse_input(puzzle_input)
      Inventories.new(
        puzzle_input.line_groups.map { |group|
          Inventory.new group.map(&:to_i)
        }
      )
    end
  end

  class Inventories
    def initialize(inventories)
      @inventories = inventories
    end

    def [](index)
      @inventories[index]
    end

    def length
      @inventories.length
    end

    def max_total_calories
      @inventories.map(&:total_calories).max
    end
  end

  class Inventory
    attr_reader :items

    def initialize(items)
      @items = items
    end

    def total_calories
      @total_calories ||= items.sum
    end
  end

  def initialize
    @input = PuzzleInput.read('01')
  end

  def setup(args)
    args.state.day01.state.animations = {}
    state = args.state.day01
    state.next_id = 0
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
      id: state.next_id += 1,
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
    process_inputs(args.inputs, state)
    render(args.outputs, state)
    update(state)
  end

  def process_inputs(inputs, state)
    mouse = inputs.mouse
    mouseover_elves = state.elves.select { |elf|
      mouse.inside_rect?({ x: elf[:x] - 16, y: elf[:y], w: 32, h: 56 })
    }
    state.mouseover_elf = mouseover_elves.min_by { |elf| elf[:y] }
    return unless mouse.click

    state.selected_elf = state.mouseover_elf
  end

  def render(gtk_outputs, state)
    gtk_outputs.primitives << {
      x: 0, y: 0, w: 1280, h: 720, path: 'maps/day01/png/Level_0.png'
    }.sprite!
    mouseover_id = state.mouseover_elf&.id
    selected_id = state.selected_elf&.id
    state.elves.each do |elf|
      elf[:sprite].update x: elf[:x] - 32, y: elf[:y]
      AnimatedSprite.update! elf[:sprite], animation: :"#{elf[:state][:type]}_#{elf[:state][:direction]}"
      gtk_outputs.primitives << elf[:sprite]
      if elf[:id] == selected_id
        gtk_outputs.primitives << {
          x: elf[:x] - 16, y: elf[:y], w: 32, h: 56, r: 255, g: 0, b: 0
        }.border!
      elsif elf[:id] == mouseover_id
        gtk_outputs.primitives << {
          x: elf[:x] - 16, y: elf[:y], w: 32, h: 56, r: 0, g: 255, b: 0
        }.border!
      end
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
        elf[:y] += 1
        elf_state[:direction] = :down if elf[:y] > 720 - 64
      when :left
        elf[:x] -= 1
        elf_state[:direction] = :right if elf[:x] < 16
      when :down
        elf[:y] -= 1
        elf_state[:direction] = :up if elf[:y].negative?
      when :right
        elf[:x] += 1
        elf_state[:direction] = :left if elf[:x] > 1280 - 16
      end
    end
  end
end

MapScreen.register Day01, day: 1, title: 'Calorie Counting', x: 70, y: 230
