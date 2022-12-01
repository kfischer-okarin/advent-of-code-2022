class MapScreen
  def tick(args)
    render(args.outputs)
  end

  def render(gtk_outputs)
    gtk_outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, path: 'jungle.png' }.sprite!
  end
end
