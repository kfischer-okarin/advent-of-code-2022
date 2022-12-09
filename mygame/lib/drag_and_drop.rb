class DragAndDrop
  def initialize(items:)
    @items = items
    @id = id
    @dragged_item = nil
    @drag_start = nil
  end

  def process_inputs(gtk_inputs)
    mouse = gtk_inputs.mouse
    if @dragged_item
      handle_drag(mouse)
    else
      handle_start_drag(mouse)
    end
  end

  private

  def handle_drag(mouse)
    if mouse.button_left
      @dragged_item[:x] = mouse.x - @drag_start[0]
      @dragged_item[:y] = mouse.y - @drag_start[1]
    else
      @dragged_item = nil
    end
  end

  def handle_start_drag(mouse)
    @items.each do |item|
      next unless mouse.click && mouse.inside_rect?(item)

      @dragged_item = item
      @drag_start = [mouse.x - item[:x], mouse.y - item[:y]]
      break
    end
  end
end
