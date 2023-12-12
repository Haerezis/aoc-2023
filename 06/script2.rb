lines = File.readlines("input")

time = lines.first.split(":").last.gsub(" ", "").to_i
distance = lines.last.split(":").last.gsub(" ", "").to_i

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

race = Race.new(1, time, distance)

puts race.solutions.count
