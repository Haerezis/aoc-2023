#lines =  %w(
#two1nine
#eightwothree
#abcone2threexyz
#xtwone3four
#4nineeightseven2
#zoneight234
#7pqrstsixteen
#)
lines = File.readlines("input", chomp: true)

# Add first/last lette of word to sub value to allow concataned values (ie two one => twone) to work.
substitutions = { 
  "one" => "o1e",
  "two" => "t2o",
  "three" => "t3e",
  "four" => "f4r",
  "five" => "f5e",
  "six" => "s6x",
  "seven" => "s7n",
  "eight" => "e8t",
  "nine" => "n9e"
}
re = Regexp.union(substitutions.keys)

only_int_lines = lines.map do |l|
  # gsub twice to sub concataned values
  l = l.gsub(re, substitutions)
  l = l.gsub(re, substitutions)
  l = l.delete("^0-9")
  l
end
calibration_values = only_int_lines.map {|l| "#{l[0]}#{l[-1]}".to_i }

#(0..calibration_values.count).each do |i|
#  puts "#{lines[i]} => #{calibration_values[i]}"
#end

result = calibration_values.sum

puts result
