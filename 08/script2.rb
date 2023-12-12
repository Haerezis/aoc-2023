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

src_nodes = graph.keys.filter {|id| id.end_with?("A")}.map {|id| graph[id]}

move_counts = []

move_counts = src_nodes.map do |node|
  move_count = 0
  while !node.id.end_with?("Z")
    direction = directions[move_count % directions.count]
    node = node.move_to(direction)
    move_count += 1
  end

  move_count
end

puts move_counts.reduce(1, :lcm)
