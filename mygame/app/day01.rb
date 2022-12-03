class Day01
  def initialize
    @input = PuzzleInput.new(1).raw
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

    state.elf_sprite = AnimatedSprite.build(
      x: 100,
      y: 100,
      path: '/sprites/elf-female.png',
      animations: state.animations
    )
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
    render(args)
  end

  def render(args)
    args.outputs.primitives << {
      x: 0, y: 0, w: 1280, h: 720, path: 'maps/day01/png/Level_0.png'
    }.sprite!
    AnimatedSprite.update! args.state.day01.elf_sprite, animation: :walk_down
    args.outputs.primitives << args.state.day01.elf_sprite
  end
end

MapScreen.register Day01, day: 1, title: 'Calorie Counting', x: 70, y: 230
