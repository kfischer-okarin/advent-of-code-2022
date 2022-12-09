class Day03
  def initialize
    @input = PuzzleInput.read('03')
  end

  def setup(args)
    state = args.state.day03 = args.state.new_entity(:day_state)
    state.items_types = prepare_item_types(args.outputs)
  end

  def prepare_item_types(gtk_outputs)
    sprites = load_shoebox_xml('sprites/genericItems_spritesheet_white.xml')
    letters = ('a'..'z').to_a + ('A'..'Z').to_a
    {}.tap { |items|
      letters.each_with_index do |letter, index|
        item = ITEMS[index]
        sprite = sprites[item[:sprite_index]]
        render_target = gtk_outputs[:"item_#{letter}"]
        render_target.width = sprite[:w]
        render_target.height = sprite[:h]
        render_target.primitives << sprite.to_sprite(x: 0, y: 0)
        render_target.primitives << sprite.to_solid(x: 0, y: 0, r: 255, g: 255, b: 255, blendmode_enum: 2)
        items[letter] = {
          letter: letter,
          priority: index + 1,
          sprite: {
            path: :"item_#{letter}",
            w: sprite[:w],
            h: sprite[:h],
            r: 100 + (rand * 64),
            g: 100 + (rand * 64),
            b: 100 + (rand * 64)
          },
          label_offset: item[:label_offset]
        }
      end
    }
  end

  def tick(args)
    state = args.state.day03
    render(args.outputs, state)
    process_inputs(args.inputs, state)
    update(state)
  end

  def render(gtk_outputs, state)
    current_x = 0
    current_y = 0
    max_h = 0
    state.items_types.each do |_, item|
      break unless item

      sprite = item[:sprite]
      if current_x + sprite[:w] > 1280
        current_x = 0
        current_y += max_h
        max_h = 0
      end

      render_item(gtk_outputs, item, x: current_x, y: current_y)
      max_h = [max_h, sprite[:h]].max
      current_x += sprite[:w]
    end
  end

  def render_item(gtk_outputs, item, x:, y:)
    sprite = item[:sprite]
    gtk_outputs.primitives << sprite.to_sprite(x: x, y: y)
    gtk_outputs.primitives << {
      x: x + item[:label_offset][0], y: y + item[:label_offset][1],
      text: item[:letter], alignment_enum: 1, vertical_alignment_enum: 1
    }.label!
  end

  ITEMS = [
    { sprite_index: 0, label_offset: [65, 70] },
    { sprite_index: 1, label_offset: [65, 75] },
    { sprite_index: 2, label_offset: [40, 20] },
    { sprite_index: 3, label_offset: [30, 38] },
    { sprite_index: 4, label_offset: [20, 28] },
    { sprite_index: 5, label_offset: [20, 22] },
    { sprite_index: 6, label_offset: [30, 50] },
    { sprite_index: 7, label_offset: [30, 50] },
    { sprite_index: 9, label_offset: [20, 30] },
    { sprite_index: 10, label_offset: [35, 70] },
    { sprite_index: 11, label_offset: [35, 40] },
    { sprite_index: 12, label_offset: [35, 40] },
    { sprite_index: 13, label_offset: [22, 30] },
    { sprite_index: 14, label_offset: [20, 30] },
    { sprite_index: 15, label_offset: [50, 90] },
    { sprite_index: 19, label_offset: [50, 100] },
    { sprite_index: 20, label_offset: [60, 140] },
    { sprite_index: 21, label_offset: [60, 130] },
    { sprite_index: 22, label_offset: [60, 145] },
    { sprite_index: 23, label_offset: [22, 40] },
    { sprite_index: 26, label_offset: [30, 55] },
    { sprite_index: 28, label_offset: [30, 70] },
    { sprite_index: 29, label_offset: [28, 20] },
    { sprite_index: 30, label_offset: [60, 50] },
    { sprite_index: 31, label_offset: [60, 60] },
    { sprite_index: 45, label_offset: [60, 30] },
    { sprite_index: 47, label_offset: [40, 50] },
    { sprite_index: 49, label_offset: [80, 80] },
    { sprite_index: 50, label_offset: [70, 70] },
    { sprite_index: 61, label_offset: [30, 40] },
    { sprite_index: 63, label_offset: [35, 50] },
    { sprite_index: 78, label_offset: [30, 15] },
    { sprite_index: 81, label_offset: [50, 35] },
    { sprite_index: 82, label_offset: [35, 90] },
    { sprite_index: 83, label_offset: [25, 40] },
    { sprite_index: 84, label_offset: [20, 40] },
    { sprite_index: 92, label_offset: [20, 55] },
    { sprite_index: 94, label_offset: [50, 80] },
    { sprite_index: 100, label_offset: [18, 13] },
    { sprite_index: 101, label_offset: [60, 50] },
    { sprite_index: 107, label_offset: [27, 30] },
    { sprite_index: 108, label_offset: [60, 60] },
    { sprite_index: 109, label_offset: [13, 20] },
    { sprite_index: 110, label_offset: [40, 15] },
    { sprite_index: 133, label_offset: [40, 70] },
    { sprite_index: 113, label_offset: [70, 40] },
    { sprite_index: 118, label_offset: [30, 50] },
    { sprite_index: 120, label_offset: [25, 30] },
    { sprite_index: 123, label_offset: [50, 50] },
    { sprite_index: 126, label_offset: [25, 50] },
    { sprite_index: 128, label_offset: [12, 30] },
    { sprite_index: 130, label_offset: [12, 30] }
  ]

  def load_shoebox_xml(path)
    xml_contents = $gtk.parse_xml_file(path)
    texture_atlas = xml_contents[:children][0]
    sprite_path = path.gsub('.xml', '.png')
    texture_atlas[:children].map { |sub_texture|
      attributes = sub_texture[:attributes]
      {
        w: attributes['width'].to_i,
        h: attributes['height'].to_i,
        path: sprite_path,
        tile_x: attributes['x'].to_i,
        tile_y: attributes['y'].to_i,
        tile_w: attributes['width'].to_i,
        tile_h: attributes['height'].to_i
      }
    }
  end

  def process_inputs(gtk_inputs, state)
  end

  def update(state)
  end
end

MapScreen.register Day03, day: 3, title: 'Rucksack Reorganization', x: 920, y: 250
