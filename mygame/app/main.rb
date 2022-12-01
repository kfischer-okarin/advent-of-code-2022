require 'app/map_screen.rb'

require 'app/day01.rb'

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
    @scenes = [initial_scene]
  end

  def active_scene
    @scenes.last
  end

  def tick(args)
    active_scene.tick(args)
    return unless next_scene

    @scenes << next_scene
    @next_scene = nil
  end
end

$gtk.reset
