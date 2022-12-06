def test_nine_slice_panel_render(args, assert)
  panel = NineSlicePanel.new(
    x: 10, y: 10, w: 200, h: 200,
    sprite: {
      path: 'panel.png', w: 100, h: 100,
      left_w: 10, right_w: 20, top_h: 30, bottom_h: 40
    }
  )

  panel.render(args.outputs)

  assert.equal! args.outputs.primitives.size, 9
  [
    {
      x: 10, y: 10, w: 10, h: 40,
      path: 'panel.png',
      source_x: 0, source_y: 0, source_w: 10, source_h: 40
    }.sprite!,
    {
      x: 20, y: 10, w: 170, h: 40,
      path: 'panel.png',
      source_x: 10, source_y: 0, source_w: 70, source_h: 40
    }.sprite!,
    {
      x: 190, y: 10, w: 20, h: 40,
      path: 'panel.png',
      source_x: 80, source_y: 0, source_w: 20, source_h: 40
    }.sprite!,
    {
      x: 10, y: 50, w: 10, h: 130,
      path: 'panel.png',
      source_x: 0, source_y: 40, source_w: 10, source_h: 30
    }.sprite!,
    {
      x: 20, y: 50, w: 170, h: 130,
      path: 'panel.png',
      source_x: 10, source_y: 40, source_w: 70, source_h: 30
    }.sprite!,
    {
      x: 190, y: 50, w: 20, h: 130,
      path: 'panel.png',
      source_x: 80, source_y: 40, source_w: 20, source_h: 30
    }.sprite!,
    {
      x: 10, y: 180, w: 10, h: 30,
      path: 'panel.png',
      source_x: 0, source_y: 70, source_w: 10, source_h: 30
    }.sprite!,
    {
      x: 20, y: 180, w: 170, h: 30,
      path: 'panel.png',
      source_x: 10, source_y: 70, source_w: 70, source_h: 30
    }.sprite!,
    {
      x: 190, y: 180, w: 20, h: 30,
      path: 'panel.png',
      source_x: 80, source_y: 70, source_w: 20, source_h: 30
    }.sprite!
  ].each do |expected_primitive|
    assert.true! args.outputs.primitives.include?(expected_primitive),
                 "Expected:\n  #{$fn.pretty_format(expected_primitive)}\n to be in:\n  #{$fn.pretty_format(args.outputs.primitives)}"
  end
end
