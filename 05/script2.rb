require "ostruct"

blocks = File.read("input").split("\n\n")

class Mapping 
  def initialize(name, data)
    @name = name

    @data = data.map do |dst, src, delta|
      OpenStruct.new(
        src: src,
        dst: dst,
        delta: delta,
        src_range: src..src+delta-1
      )
    end.sort_by(&:src)
  end

  def to_s
    @data.map {|d| "#{d.src_range} ====> #{d.dst..d.dst+d.delta-1} (#{d.delta}) #{d.dst - d.src}"}.join("\n")
  end

  def translate(range)
    retval = []

    mapping_queue = @data.filter {|d| d.src_range.cover?(range.first) || range.cover?(d.src_range.first) }

    first_mapping = mapping_queue.first
    if first_mapping && first_mapping.src_range.first < range.first
      diff = range.first - first_mapping.src

      first_mapping = OpenStruct.new(
        src: first_mapping.src + diff,
        dst: first_mapping.dst + diff,
        delta: first_mapping.delta - diff
      )
      first_mapping.src_range = first_mapping.src..first_mapping.src+first_mapping.delta-1

      mapping_queue[0] = first_mapping
    end

    last_mapping = mapping_queue.last
    if last_mapping && range.last < last_mapping.src_range.last
      diff = last_mapping.src_range.last - range.last

      last_mapping = OpenStruct.new(
        src: last_mapping.src,
        dst: last_mapping.dst,
        delta: last_mapping.delta - diff
      )
      last_mapping.src_range = last_mapping.src..last_mapping.src+last_mapping.delta-1

      mapping_queue[-1] = last_mapping
    end


    while range
      head_mapping = mapping_queue.first

      if head_mapping.nil?
        retval.push(range)
        range = nil
      elsif range.first < head_mapping.src
        retval.push(range.first..head_mapping.src-1)
        range = head_mapping.src..range.last
      else
        retval.push(head_mapping.dst..head_mapping.dst+head_mapping.delta-1)
        range = (range.first + head_mapping.delta)..range.last
        mapping_queue.shift
      end

      if range && range.first > range.last
        range = nil
      end
    end

    retval
  end
end

seeds_part = blocks.first
mappings_part = blocks[1..]

seed_ranges = seeds_part.split(": ").last.split(" ").map(&:to_i).each_slice(2).map {|seed, delta| seed..(seed+delta-1)}

mappings = mappings_part.map do |blok|
  blok = blok.lines.map(&:strip)

  name = blok.first.split(" ").first
  data = blok[1..].map {|l| l.split(" ").map(&:to_i) }

  Mapping.new(name, data)
end

ranges = seed_ranges
mappings.each do |mapping|
  ranges = ranges.map do |range|
    mapping.translate(range)
  end.flatten.uniq.sort_by(&:first)
end

puts ranges.first.first
