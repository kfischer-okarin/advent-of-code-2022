require 'lib/animated_sprite.rb'
require 'lib/animations.rb'
require 'lib/nine_slice_panel.rb'

require 'app/map_screen.rb'
require 'app/puzzle_input.rb'
require 'app/ui.rb'

require 'app/day01.rb'
require 'app/day02.rb'

def tick(args)
  setup(args) if args.tick_count.zero?
  $scene_manager.tick(args)
end

def setup(_args)
  $scene_manager = SceneManager.new(MapScreen.new)
end

class SceneManager
  attr_accessor :next_scene

  def initialize(initial_scene)
    @scenes = []
    @next_scene = initial_scene
  end

  def active_scene
    @scenes.last
  end

  def pop_scene
    @scenes.pop
  end

  def tick(args)
    active_scene&.tick(args)
    @scenes.pop if @scenes.size > 1 && args.inputs.keyboard.key_down.escape
    unless $gtk.production
      args.outputs.primitives << { x: 0, y: 720, text: $gtk.current_framerate.round.to_s, r: 255, g: 255, b: 255 }
    end
    return unless next_scene

    @scenes << next_scene
    @next_scene = nil
    active_scene.setup(args) if active_scene.methods(false).include? :setup
  end
end

$gtk.reset
