lines = File.readlines("input")

directions = lines.first.strip.split("")

graph_lines = lines[2..].map do |l|
  id, connections = l.split(" = ")
  left, right = connections.strip[1..-2].split(", ")

  [id, left, right]
end

class GraphNode
  attr_reader :id
  attr_reader :left
  attr_reader :right

  def initialize(id)
    @id = id
  end

  def to_s
    "#{@id} = (#{@left&.id}, #{@right&.id})"
  end

  def set_connection(left, right)
    @left = left
    @right = right
  end

  def move_to(direction)
    direction == "L" ? @left : @right
  end
end

graph = {}
graph_lines.each do |id, left, right|
  graph[id] = GraphNode.new(id)
end
graph_lines.each do |id, left, right|
  graph[id].set_connection(
    graph[left],
    graph[right]
  )
end

current_node = graph["AAA"]
move_count = 0

while current_node.id != "ZZZ"
  direction = directions[move_count % directions.count]
  current_node = current_node.move_to(direction)
  move_count += 1
end

puts move_count
