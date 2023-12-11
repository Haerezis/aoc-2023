blocks = File.read("input").split("\n\n")

class Mapping 
  def initialize(name, data)
    @name = name

    @data = data.map do |dst, src, delta|
      [src..src+delta, dst]
    end.sort_by {|range, dst| range.first}
  end

  def translate(value)
    mapping = @data.find {|item| item.first.include?(value)}
    if mapping.nil?
      mapping = [value..value, value]
    end

    range, dst = mapping
    delta = value - range.first

    dst + delta
  end
end

seeds_part = blocks.first
mappings_part = blocks[1..]

seeds = seeds_part.split(": ").last.split(" ").map(&:to_i)
mappings = mappings_part.map do |blok|
  blok = blok.lines.map(&:strip)

  name = blok.first.split(" ").first
  data = blok[1..].map {|l| l.split(" ").map(&:to_i) }

  Mapping.new(name, data)
end

locations = seeds.map do |seed|
  retval = seed
  mappings.each do |mapping|
    retval = mapping.translate(retval)
  end

  retval
end

puts locations.min
