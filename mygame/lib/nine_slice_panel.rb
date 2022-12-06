class NineSlicePanel
  def initialize(x:, y:, w:, h:, sprite:)
    @x = x
    @y = y
    @w = w
    @h = h
    @sprite = sprite
  end

  def render(gtk_outputs)
    gtk_outputs.primitives << [
      bottom_left,
      bottom_center,
      bottom_right,
      left,
      center,
      right,
      top_left,
      top_center,
      top_right
    ]
  end

  def bottom_left
    {
      x: @x, y: @y, w: @sprite[:left_w], h: @sprite[:bottom_h],
      path: @sprite[:path],
      source_x: 0, source_y: 0,
      source_w: @sprite[:left_w], source_h: @sprite[:bottom_h]
    }.sprite!
  end

  def bottom_center
    {
      x: @x + @sprite[:left_w], y: @y, w: @w - @sprite[:left_w] - @sprite[:right_w], h: @sprite[:bottom_h],
      path: @sprite[:path],
      source_x: @sprite[:left_w], source_y: 0,
      source_w: @sprite[:w] - @sprite[:left_w] - @sprite[:right_w], source_h: @sprite[:bottom_h]
    }.sprite!
  end

  def bottom_right
    {
      x: @x + @w - @sprite[:right_w], y: @y, w: @sprite[:right_w], h: @sprite[:bottom_h],
      path: @sprite[:path],
      source_x: @sprite[:w] - @sprite[:right_w], source_y: 0,
      source_w: @sprite[:right_w], source_h: @sprite[:bottom_h]
    }.sprite!
  end

  def left
    {
      x: @x, y: @y + @sprite[:bottom_h], w: @sprite[:left_w], h: @h - @sprite[:bottom_h] - @sprite[:top_h],
      path: @sprite[:path],
      source_x: 0, source_y: @sprite[:bottom_h],
      source_w: @sprite[:left_w], source_h: @sprite[:h] - @sprite[:bottom_h] - @sprite[:top_h]
    }.sprite!
  end

  def center
    {
      x: @x + @sprite[:left_w], y: @y + @sprite[:bottom_h],
      w: @w - @sprite[:left_w] - @sprite[:right_w], h: @h - @sprite[:bottom_h] - @sprite[:top_h],
      path: @sprite[:path],
      source_x: @sprite[:left_w], source_y: @sprite[:bottom_h],
      source_w: @sprite[:w] - @sprite[:left_w] - @sprite[:right_w],
      source_h: @sprite[:h] - @sprite[:bottom_h] - @sprite[:top_h]
    }.sprite!
  end

  def right
    {
      x: @x + @w - @sprite[:right_w], y: @y + @sprite[:bottom_h],
      w: @sprite[:right_w], h: @h - @sprite[:bottom_h] - @sprite[:top_h],
      path: @sprite[:path],
      source_x: @sprite[:w] - @sprite[:right_w], source_y: @sprite[:bottom_h],
      source_w: @sprite[:right_w], source_h: @sprite[:h] - @sprite[:bottom_h] - @sprite[:top_h]
    }.sprite!
  end

  def top_left
    {
      x: @x, y: @y + @h - @sprite[:top_h], w: @sprite[:left_w], h: @sprite[:top_h],
      path: @sprite[:path],
      source_x: 0, source_y: @sprite[:h] - @sprite[:top_h],
      source_w: @sprite[:left_w], source_h: @sprite[:top_h]
    }.sprite!
  end

  def top_center
    {
      x: @x + @sprite[:left_w], y: @y + @h - @sprite[:top_h],
      w: @w - @sprite[:left_w] - @sprite[:right_w], h: @sprite[:top_h],
      path: @sprite[:path],
      source_x: @sprite[:left_w], source_y: @sprite[:h] - @sprite[:top_h],
      source_w: @sprite[:w] - @sprite[:left_w] - @sprite[:right_w], source_h: @sprite[:top_h]
    }.sprite!
  end

  def top_right
    {
      x: @x + @w - @sprite[:right_w], y: @y + @h - @sprite[:top_h],
      w: @sprite[:right_w], h: @sprite[:top_h],
      path: @sprite[:path],
      source_x: @sprite[:w] - @sprite[:right_w], source_y: @sprite[:h] - @sprite[:top_h],
      source_w: @sprite[:right_w], source_h: @sprite[:top_h]
    }.sprite!
  end
end
