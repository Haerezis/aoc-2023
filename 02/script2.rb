lines = File.readlines("input", chomp: true)
#lines = "
#Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
#Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
#Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
#Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
#Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
#".split("\n")[1..]

puts lines

records = lines.map do |line|
  line = line.split(':')
  
  id = line.first.split(" ").last.to_i
  
  data = line.last.split(";").map do |game_data|
    retval = { red: 0, green: 0, blue: 0}
    game_data.split(",").map(&:strip).map {|color_data| color_data.split(" ")}.each do |number, color|
      retval[color.to_sym] = number.to_i
    end

    retval
  end

  [id, data]
end

processed_records = records.map do |id, data|
  max_red = data.map {|d| d[:red]}.max
  max_green = data.map {|d| d[:green]}.max
  max_blue = data.map {|d| d[:blue]}.max

  res = max_red * max_green * max_blue

  [
    res,
    id,
    {max_red: max_red, max_green: max_green, max_blue: max_blue},
    data
  ]
end

puts processed_records
puts processed_records.map(&:first).sum
