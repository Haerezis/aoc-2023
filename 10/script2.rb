lines = File.readlines("input")

def direction_data
  { 
  up: [-1, 0],
  down: [1, 0],
  left: [0, -1],
  right: [0, 1]
}
end

def cell_data
  {
  '|' => {
    up: true,
    down: true,
  },
  '-' => {
    left: true,
    right: true
  },
  'L' => {
    up: true,
    right: true
  },
  'J' => {
    up: true,
    left: true,
  },
  '7' => {
    down: true,
    left: true,
  },
  'F' => {
    down: true,
    right: true
  },
  'S' => {
    up: true,
    down: true,
    left: true,
    right: true
  },
}
end

def find_start(matrix)
  start_position = []
  matrix.each_with_index do |line_data, line|
    line_data.each_with_index do |cell, column|
      if cell == "S"
        return [line, column]
      end
    end
  end
end

def find_initial_cells(matrix, loop_value)
  positions = []
  positions += (0..matrix.count-1).map {|line| [0, matrix.first.count-1].map {|col| [line, col]}}.flatten(1)
  positions += [0, matrix.count-1].map {|line| (0..matrix.first.count-1).map {|col| [line, col]}}.flatten(1)
  positions.filter {|l,c| matrix[l][c] != loop_value}
end

def connected_pipe_cells(matrix, source_position)
  cell = matrix[source_position.first][source_position.last]
  source_cell_data = cell_data[cell]

  if source_cell_data.nil?
    return []
  end

  retval = []
  source_cell_data.keys.each do |dir|
    dir_delta = direction_data[dir]
    target_pos = [source_position.first + dir_delta.first, source_position.last + dir_delta.last]

    if !validate_pos(matrix, *target_pos)
      next
    end

    target_cell = matrix[target_pos.first][target_pos.last]
    target_cell_data = cell_data[target_cell]

    if target_cell_data.nil?
      next
    end
    if dir == :up && !target_cell_data[:down] ||
        dir == :down && !target_cell_data[:up] ||
        dir == :left && !target_cell_data[:right] ||
        dir == :right && !target_cell_data[:left]
      next
    end

    retval.push(target_pos)
  end

  retval
end

def connected_out_of_loop_cells(matrix, source_position, loop_value)
  retval = []

  [-1, 1].each do |line_delta|
    [-1, 1].each do |col_delta|
      line = source_position.first + line_delta
      col = source_position.last + col_delta

      if validate_pos(matrix, line, col) && ![loop_value, "O"].include?(matrix[line][col])
        retval.push([line, col])
      end
    end
  end

  retval
end

def validate_pos(matrix, line, column)
  0 <= line && line < matrix.count && 0 <= column && column < matrix.first.count
end

def flood_out_of_loop(matrix, loop_value, source_cells, value)
  new_source_cells = []

  source_cells.each do |line, column|
    pos = [line, column]
    possible_cells = connected_out_of_loop_cells(matrix, pos, loop_value)
    possible_cells.delete(pos)

    new_source_cells += possible_cells
    matrix[line][column] = value
  end

  new_source_cells
end

def flood_pipe(matrix, source_cells, value)
  new_source_cells = []

  source_cells.each do |line, column|
    pos = [line, column]
    possible_cells = connected_pipe_cells(matrix, pos)
    possible_cells.delete(pos)

    new_source_cells += possible_cells
    matrix[line][column] = value
  end

  new_source_cells
end

def print_matrix(matrix)
  puts matrix.map {|l| l.join("")}
  puts
end

def inspect_matrix(matrix)
  puts matrix.map(&:inspect)
end

def expand_matrix(matrix)
  retval = Array.new(matrix.count * 3) do |i|
    Array.new(matrix.first.count * 3, ".")
  end

  matrix.each_with_index do |line_data, line|
    line_data.each_with_index do |cell, column|
      retval_cell_line = line * 3 + 1
      retval_cell_col = column * 3 + 1

      retval[retval_cell_line][retval_cell_col] = cell

      case cell
      when '-'
        retval[retval_cell_line][retval_cell_col-1] = '-'
        retval[retval_cell_line][retval_cell_col+1] = '-'
      when '|'
        retval[retval_cell_line-1][retval_cell_col] = '|'
        retval[retval_cell_line+1][retval_cell_col] = '|'
      when 'L'
        retval[retval_cell_line][retval_cell_col+1] = '-'
        retval[retval_cell_line-1][retval_cell_col] = '|'
      when 'J'
        retval[retval_cell_line][retval_cell_col-1] = '-'
        retval[retval_cell_line-1][retval_cell_col] = '|'
      when '7'
        retval[retval_cell_line][retval_cell_col-1] = '-'
        retval[retval_cell_line+1][retval_cell_col] = '|'
      when 'F'
        retval[retval_cell_line][retval_cell_col+1] = '-'
        retval[retval_cell_line+1][retval_cell_col] = '|'
      when 'S'
        if cell_data[matrix[line-1][column]]&.dig(:down)
          retval[retval_cell_line-1][retval_cell_col] = '|'
        end
        if cell_data[matrix[line+1][column]]&.dig(:up)
          retval[retval_cell_line+1][retval_cell_col] = '|'
        end
        if cell_data[matrix[line][column-1]]&.dig(:right)
          retval[retval_cell_line][retval_cell_col-1] = '-'
        end
        if cell_data[matrix[line][column+1]]&.dig(:left)
          retval[retval_cell_line][retval_cell_col+1] = '-'
        end
      end
    end 
  end

  retval
end


def mark_out_of_loop(matrix, loop_value)
  flood_edge_cells = find_initial_cells(matrix, loop_value)
  while !flood_edge_cells.empty?
    flood_edge_cells = flood_out_of_loop(matrix, loop_value, flood_edge_cells, "O")
    flood_edge_cells.uniq!
  end
end

def mark_loop(matrix, loop_value)
  start_position = find_start(matrix)
  flood_edge_cells = [start_position]

  while !flood_edge_cells.empty?
    flood_edge_cells = flood_pipe(matrix, flood_edge_cells, loop_value)
    flood_edge_cells.uniq!
  end
end

matrix = lines.map {|l| l.strip.split("")}
matrix2 = expand_matrix(matrix)

mark_loop(matrix2, "Z")
mark_out_of_loop(matrix2, "Z")

count = 0
matrix.each_with_index do |line_data, line|
  line_data.each_with_index do |cell, column|
    cell_line = line * 3 + 1
    cell_col = column * 3 + 1

    if !["O", "Z"].include?(matrix2[cell_line][cell_col])
      count += 1
    end
  end 
end

puts count
