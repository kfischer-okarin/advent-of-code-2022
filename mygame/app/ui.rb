module UI
  class << self
    def draw_panel(gtk_outputs, x:, y:, w:, h:)
      panel = NineSlicePanel.new(
        x: x, y: y, w: w, h: h,
        sprite: {
          path: 'sprites/panel.png', w: 128, h: 128,
          left_w: 60, right_w: 56, top_h: 44, bottom_h: 52
        }
      )
      panel.render(gtk_outputs)
    end

    def draw_wood_panel(gtk_outputs, x:, y:, w:, h:)
      panel = NineSlicePanel.new(
        x: x, y: y, w: w, h: h,
        sprite: {
          path: 'sprites/panel_wood.png', w: 128, h: 128,
          left_w: 30, right_w: 30, top_h: 30, bottom_h: 30
        }
      )
      panel.render(gtk_outputs)
    end

    def draw_button(gtk_outputs, x:, y:, w:, h:, text:, size_enum: 3)
      button = NineSlicePanel.new(
        x: x, y: y, w: w, h: h,
        sprite: {
          path: 'sprites/button_red.png', w: 80, h: 40,
          left_w: 30, right_w: 30, top_h: 10, bottom_h: 10
        }
      )
      button.render(gtk_outputs)
      gtk_outputs.primitives << {
        x: x + w.half, y: y + h.half, text: text,
        size_enum: size_enum, alignment_enum: 1, vertical_alignment_enum: 1,
        r: 255, g: 255, b: 255
      }.label!
    end
  end
end
