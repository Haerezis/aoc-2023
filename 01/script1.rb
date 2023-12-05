lines = File.readlines("input", chomp: true)

only_int_lines = lines.map {|l| l.delete("^0-9") }
calibration_values = only_int_lines.map {|l| "#{l[0]}#{l[-1]}".to_i }
result = calibration_values.sum

puts result
