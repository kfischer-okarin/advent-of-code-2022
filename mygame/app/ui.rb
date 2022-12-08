module UI
  class << self
    def draw_panel(gtk_outputs, x:, y:, w:, h:)
      panel = NineSlicePanel.new(
        x: x, y: y, w: w, h: h,
        sprite: {
          path: 'sprites/panel.png', w: 128, h: 128,
          left_w: 60, right_w: 60, top_h: 60, bottom_h: 60
        }
      )
      panel.render(gtk_outputs)
    end
  end
end
