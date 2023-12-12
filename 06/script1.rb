lines = File.readlines("input")

times = lines.first.split(":").last.strip.split(" ").map(&:to_i)
distances = lines.last.split(":").last.strip.split(" ").map(&:to_i)

class Race
  def initialize(id, time, distance)
    @id = id
    @time = time 
    @distance = distance
  end

  def to_s
    "Race #{@id}: Time #{@time}, Distance #{@distance}"
  end

  def solutions
    (1..@time-1).map do |sol|
      if (@time - sol) * sol > @distance
        sol
      else
        nil
      end
    end.keep_if {|i| !i.nil? }
  end
end

races = times.each_with_index.map {|time, i| Race.new(i+1, time, distances[i])}

puts races.map(&:solutions).map(&:count).inject(&:*)
