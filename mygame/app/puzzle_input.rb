class PuzzleInput
  def self.read(filename)
    new $gtk.read_file("inputs/#{filename}.txt")
  end

  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def lines
    @lines ||= raw.split("\n")
  end

  def line_groups
    @line_groups ||= raw.split("\n\n").map { |group| group.split("\n") }
  end
end
