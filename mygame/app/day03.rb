class Day03
  class Rucksack
    ITEM_TYPES = (('a'..'z').to_a + ('A'..'Z').to_a).freeze

    class << self
      def parse_rucksacks(input)
        input.lines.map { |line|
          Rucksack.new(
            compartment1: line[0...line.length.idiv(2)].chars,
            compartment2: line[line.length.idiv(2)..].chars
          )
        }
      end

      def item_type_priority(item_type)
        ITEM_TYPES.index(item_type) + 1
      end

      def split_into_security_groups(rucksacks)
        rucksacks.each_slice(3).to_a
      end

      def common_items(*rucksacks)
        rucksacks.reduce(ITEM_TYPES) { |common_items, rucksack|
          common_items & rucksack.all_items
        }
      end
    end

    attr_reader :compartment1, :compartment2

    def initialize(compartment1:, compartment2:)
      @compartment1 = compartment1
      @compartment2 = compartment2
    end

    def wrongly_sorted_item_types
      compartment1 & compartment2
    end

    def all_items
      compartment1 + compartment2
    end

    def item_count
      all_items.count
    end
  end

  def initialize
    @input = PuzzleInput.read('03')
    @all_rucksacks = Rucksack.parse_rucksacks(@input)
    @security_groups = Rucksack.split_into_security_groups(@all_rucksacks)
    # Choose the group with the fewest items for game
    @rucksacks = @security_groups.min_by { |rucksacks| rucksacks.map(&:item_count).sum }
    @left_arrow_rect = { x: 485, y: 650, w: 44, h: 42 }
    @right_arrow_rect = { x: 750, y: 650, w: 44, h: 42 }
    @duplicate_item_button_rect = { x: 20, y: 20, w: 250, h: 40 }
    @common_item_button_rect = { x: 290, y: 20, w: 220, h: 40 }
  end

  def setup(args)
    state = args.state.day03 = args.state.new_entity(:day_state)
    state.item_types = prepare_item_types(args.outputs)
    state.rucksacks = @rucksacks.map { |rucksack|
      prepare_rucksack(rucksack, state.item_types)
    }
    change_rucksack(state, 0)
  end

  def prepare_item_types(gtk_outputs)
    sprites = load_shoebox_xml('sprites/genericItems_spritesheet_white.xml')
    {}.tap { |items|
      Rucksack::ITEM_TYPES.each_with_index do |letter, index|
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

  def prepare_rucksack(rucksack, item_types)
    [].tap { |items|
      rucksack.compartment1.each do |letter|
        items << place_item_in(item_types[letter], { x: 0, y: 0, w: 640, h: 620 })
      end

      rucksack.compartment2.each do |letter|
        items << place_item_in(item_types[letter], { x: 640, y: 0, w: 640, h: 620 })
      end
    }
  end

  def place_item_in(item_type, rect)
    sprite = item_type[:sprite]

    {
      x: rect.left + (rand * (rect.w - sprite[:w])).floor,
      y: rect.bottom + (rand * (rect.h - sprite[:h]).floor),
      w: sprite[:w],
      h: sprite[:h],
      item_type: item_type
    }
  end

  def tick(args)
    state = args.state.day03
    render(args.outputs, state)
    process_inputs(args.inputs, state)
    update(state)
  end

  def render(gtk_outputs, state)
    gtk_outputs.primitives << { x: 640, y: 0, x2: 640, y2: 628, r: 0, g: 0, b: 0 }.line!

    # Render in reverse order so that earlier items are rendered on top
    # since the drag and drop starts dragging the first item it finds
    current_rucksack(state).reverse_each do |item|
      render_item(gtk_outputs, item[:item_type], x: item[:x], y: item[:y])
    end

    UI.draw_panel(gtk_outputs, x: 540, y: 624, w: 200, h: 96)
    gtk_outputs.primitives << {
      x: 640, y: 685,
      text: "Rucksack #{state.rucksack_index + 1}", size_enum: 3, alignment_enum: 1
    }.label!
    UI.draw_wood_panel(gtk_outputs, x: 220, y: 620, w: 200, h: 80)
    gtk_outputs.primitives << {
      x: 320, y: 675,
      text: 'Compartment 1', size_enum: 3, alignment_enum: 1,
      r: 255, g: 255, b: 255
    }.label!
    UI.draw_wood_panel(gtk_outputs, x: 860, y: 620, w: 200, h: 80)
    gtk_outputs.primitives << {
      x: 960, y: 675,
      text: 'Compartment 2', size_enum: 3, alignment_enum: 1,
      r: 255, g: 255, b: 255
    }.label!

    if state.rucksack_index.positive?
      gtk_outputs.primitives << @left_arrow_rect.to_sprite(path: 'sprites/arrow_left.png')
    end
    if state.rucksack_index < @rucksacks.size - 1
      gtk_outputs.primitives << @right_arrow_rect.to_sprite(path: 'sprites/arrow_right.png')
    end

    UI.draw_button(gtk_outputs, text: 'Select duplicate item', size_enum: 1, **@duplicate_item_button_rect)
    UI.draw_button(gtk_outputs, text: 'Select common item', size_enum: 1, **@common_item_button_rect)
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
    @drag_and_drop.process_inputs(gtk_inputs)
    handle_change_rucksack(gtk_inputs, state)
  end

  def handle_change_rucksack(gtk_inputs, state)
    mouse = gtk_inputs.mouse
    return unless mouse.click

    if mouse.inside_rect? @left_arrow_rect
      state.rucksack_index = [state.rucksack_index - 1, 0].max
    elsif  mouse.inside_rect? @right_arrow_rect
      state.rucksack_index = [state.rucksack_index + 1, state.rucksacks.size - 1].min
    end
  end

  def update(state)
  end

  def current_rucksack(state)
    state.rucksacks[state.rucksack_index]
  end

  def change_rucksack(state, rucksack_index)
    state.rucksack_index = rucksack_index
    @drag_and_drop = DragAndDrop.new(items: current_rucksack(state))
  end
end

MapScreen.register Day03, day: 3, title: 'Rucksack Reorganization', x: 920, y: 250
