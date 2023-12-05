def is_integer?(v)
  v.to_i.to_s == v
end

lines = File.readlines("input").map(&:strip)

matrix = lines.map {|l| l.split("")}

line_count = matrix.count
column_count = matrix.first.count

# Extract symbole positions
symbole_positions = []
matrix.each_with_index do |line_data, line|
  line_data.each_with_index do |cell, column|
    if !is_integer?(cell) && cell != "."
      symbole_positions.push([cell, line, column])
    end
  end
end

# Extract symbole adjacent number positions
integer_positions = []
symbole_positions.each do |symbole, line, column|
  (-1..1).each do |line_inc|
    (-1..1).each do |column_inc|
      lookup_line = line + line_inc
      lookup_column = column + column_inc

      if 0 <= lookup_line && lookup_line < line_count && 0 <= lookup_column && lookup_column < column_count
        cell = matrix[lookup_line][lookup_column]
        if is_integer?(cell)
          integer_positions.push([cell, lookup_line, lookup_column])
        end
      end
    end
  end
end


# Extract whole number
whole_integer_positions = []
integer_positions.each do |v, line, column|
  lookup_column = column
  while lookup_column > 0 && is_integer?(matrix[line][lookup_column - 1])
    lookup_column -= 1
  end
  whole_integer_positions.push([
    matrix[line][lookup_column],
    line,
    lookup_column
  ])
end
whole_integer_positions.uniq!

# Search for end of integer in line
integers = []
whole_integer_positions.each do |v, line, column|
  lookup_column = column
  while lookup_column < column_count && is_integer?(matrix[line][lookup_column + 1])
    lookup_column += 1
  end

  integers.push([
    lines[line][column..lookup_column],
    line,
    column,
    lookup_column
  ])
end

puts integers.map(&:first).map(&:to_i).sum
