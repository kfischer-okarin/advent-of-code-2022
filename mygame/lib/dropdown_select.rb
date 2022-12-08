module DropdownSelect
  class << self
    def build(x:, y:, w:, options:, size_enum: nil, selected: nil)
      row_height = $gtk.calcstringbox('A', size_enum || 1).last + 10
      {
        x: x, y: y, w: w, h: row_height, open: false, options: options,
        selected: selected && options.find { |option| option[:value] == selected },
        popup: {
          x: x, y: y - (row_height * (options.size - 1)),
          w: w, h: row_height * options.size,
          mouseover_index: 0,
          option_rects: options.map_with_index { |option, index|
            {
              x: x,
              y: y - row_height * (index - 1),
              w: w,
              h: row_height,
              option: option
            }
          }
        },
      }
    end

    def render_select(gtk_outputs, dropdown_select)
      gtk_outputs.primitives << [
        {
          x: dropdown_select[:x], y: dropdown_select[:y], w: dropdown_select[:w], h: dropdown_select[:h],
          r: 255, g: 255, b: 255
        }.solid!,
        {
          x: dropdown_select[:x], y: dropdown_select[:y], w: dropdown_select[:w], h: dropdown_select[:h],
          r: 0, g: 0, b: 0, a: 255
        }.border!,
        {
          x: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h],
          y: dropdown_select[:y] + 1,
          x2: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h],
          y2: dropdown_select[:y] + dropdown_select[:h],
          r: 0, g: 0, b: 0, a: 255
        }.line!,
        {
          x: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.66,
          y: dropdown_select[:y] + dropdown_select[:h] * 0.66,
          x2: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.5,
          y2: dropdown_select[:y] + dropdown_select[:h] * 0.33,
          r: 0, g: 0, b: 0, a: 255
        }.line!,
        {
          x: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.33,
          y: dropdown_select[:y] + dropdown_select[:h] * 0.66,
          x2: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.5,
          y2: dropdown_select[:y] + dropdown_select[:h] * 0.33,
          r: 0, g: 0, b: 0, a: 255
        }.line!,
        {
          x: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.66,
          y: dropdown_select[:y] + dropdown_select[:h] * 0.66,
          x2: dropdown_select[:x] + dropdown_select[:w] - dropdown_select[:h] * 0.33,
          y2: dropdown_select[:y] + dropdown_select[:h] * 0.66,
          r: 0, g: 0, b: 0, a: 255
        }.line!
      ]
      return unless dropdown_select[:selected]

      gtk_outputs.primitives << [
        {
          x: dropdown_select[:x] + 5,
          y: dropdown_select[:y] + dropdown_select[:h] - 5,
          text: dropdown_select[:selected][:label],
          size_enum: 1,
          r: 0, g: 0, b: 0
        }.label!
      ]
    end

    def render_popup(gtk_outputs, dropdown_select)
      return unless dropdown_select[:open]

      popup = dropdown_select[:popup]
      gtk_outputs.primitives << [
        popup.to_solid(r: 255, g: 255, b: 255),
        popup.to_border(r: 0, g: 0, b: 0),
        {
          x: popup[:x] + 1,
          y: popup[:y] + dropdown_select[:h] * (dropdown_select[:options].size - popup[:mouseover_index] - 1) + 1,
          w: popup[:w] - 2,
          h: dropdown_select[:h] - 2,
          r: 128, g: 128, b: 255
        }.solid!
      ]
      popup[:option_rects].each do |option_rect|
        gtk_outputs.primitives << [
          {
            x: option_rect[:x] + 5,
            y: option_rect[:y] - 5,
            text: option_rect[:option][:label],
            size_enum: 1,
            r: 0, g: 0, b: 0
          }.label!
        ]
      end
    end

    def process_inputs!(gtk_inputs, dropdown_select)
      mouse = gtk_inputs.mouse

      if dropdown_select[:open]
        handle_open_select(mouse, dropdown_select)
      else
        handle_closed_select(mouse, dropdown_select)
      end
    end

    private

    def handle_open_select(mouse, dropdown_select)
      popup = dropdown_select[:popup]
      if mouse.inside_rect?(popup)
        popup[:mouseover_index] = dropdown_select[:options].size - ((mouse.y - popup[:y]) / dropdown_select[:h]).to_i - 1
        if mouse.click
          dropdown_select[:open] = false
          dropdown_select[:selected] = dropdown_select[:options][popup[:mouseover_index]]
        end
        true
      else
        dropdown_select[:open] = false if mouse.click
        false
      end
    end

    def handle_closed_select(mouse, dropdown_select)
      return unless mouse.click

      if mouse.inside_rect?(dropdown_select)
        dropdown_select[:open] = true
      end
      false
    end
  end
end
