class Day01
  def tick(args)
    render(args)
  end

  def render(args)
    args.outputs.primitives << {
      x: 0, y: 0, w: 1280, h: 720, path: 'maps/day01/png/Level_0.png'
    }.sprite!
  end
end

MapScreen.register Day01, day: 1, title: 'Calorie Counting', x: 70, y: 230
