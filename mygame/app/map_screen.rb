class MapScreen
  SCENE_BUTTON_SIZE = 40

  class << self
    def register(scene_class, day:, title:, x:, y:)
      scenes[day] = {
        scene_class: scene_class,
        day: day,
        title: title,
        x: x - SCENE_BUTTON_SIZE.idiv(2),
        y: y - SCENE_BUTTON_SIZE.idiv(2),
        w: SCENE_BUTTON_SIZE,
        h: SCENE_BUTTON_SIZE
      }
    end

    def scenes
      @scenes ||= {}
    end
  end

  def setup(args)
    args.audio[:ambience] = {
      input: 'audio/Jungle.ogg',
      looping: true
    }
  end

  def tick(args)
    state = args.state.map_screen ||= {}
    process_inputs(args.inputs, state)
    render(args.outputs, state)
  end

  private

  def process_inputs(gtk_inputs, state)
    mouse = gtk_inputs.mouse
    state.mouse_over_scene = MapScreen.scenes.values.find { |scene|
      mouse.point.inside_rect?(scene)
    }
    return unless state.mouse_over_scene && mouse.click

    $scene_manager.next_scene = state.mouse_over_scene[:scene_class].new
  end

  def render(gtk_outputs, state)
    render_background(gtk_outputs)
    render_scene_buttons(gtk_outputs)
    render_scene_label(gtk_outputs, state.mouse_over_scene) if state.mouse_over_scene
  end

  def render_background(gtk_outputs)
    gtk_outputs.primitives << {
      x: 0, y: 0, w: 1280, h: 720,
      source_x: 0, source_y: 48, source_w: 1280, source_h: 720,
      path: 'sprites/jungle-bg.png'
    }.sprite!
  end

  def render_scene_buttons(gtk_outputs)
    MapScreen.scenes.each do |day, scene|
      gtk_outputs.primitives << scene.to_solid(r: 255, g: 255, b: 255)
      gtk_outputs.primitives << {
        x: scene[:x] + SCENE_BUTTON_SIZE.idiv(2),
        y: scene[:y] + SCENE_BUTTON_SIZE.idiv(2),
        text: day.to_s,
        size_enum: 5, alignment_enum: 1, vertical_alignment_enum: 1
      }
      gtk_outputs.primitives << scene.to_border(r: 0, g: 0, b: 0)
    end
  end

  def render_scene_label(gtk_outputs, scene)
    label = "--- Day #{scene[:day]}: #{scene[:title]} ---"
    label_size = $gtk.calcstringbox(label, 5, 'font.ttf')
    banner_width = label_size[0] + 40
    banner_rect = { x: 640 - banner_width.idiv(2), y: 660, w: banner_width, h: 40 }
    gtk_outputs.primitives << banner_rect.to_solid(r: 255, g: 255, b: 255)
    gtk_outputs.primitives << {
      x: 640, y: 680, text: label,
      size_enum: 5, alignment_enum: 1, vertical_alignment_enum: 1
    }.label!
    gtk_outputs.primitives << banner_rect.to_border(r: 0, g: 0, b: 0)
  end
end
