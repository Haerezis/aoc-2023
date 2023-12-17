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

def connected_cells(matrix, source_position)
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

def validate_pos(matrix, line, column)
  0 <= line && line < matrix.count && 0 <= column && column < matrix.first.count
end

def flood(matrix, source_cells, step)
  new_source_cells = []

  source_cells.each do |line, column|
    pos = [line, column]
    possible_cells = connected_cells(matrix, pos)
    possible_cells.delete(pos)

    new_source_cells += possible_cells
    matrix[line][column] = step
  end

  new_source_cells
end

def print_matrix(matrix)
  puts matrix.map {|l| l.join("")}
end

matrix = lines.map {|l| l.split("")}

column_count = matrix.first.count
line_count = matrix.count

start_position = find_start(matrix)

step = 0
flood_edge_cells = [start_position]

while !flood_edge_cells.empty?
  flood_edge_cells = flood(matrix, flood_edge_cells, step)
  flood_edge_cells.uniq!
  step += 1
end

puts step-1
