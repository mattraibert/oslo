class Node
  attr_reader :name

  def initialize(name)
    @name = name
    @successors = []
  end

  def add_edge(successor)
    @successors << successor
  end

  def to_s
    "#{ @name} -> [#{@successors.map(&:name).join(' ')}]"
  end

  def to_h
    @successors.map { |successor| {source: name, target: successor.name, type: 'follow' } }
  end

  def to_json
    to_h.to_json
  end
end

class Graph
  def initialize
    @nodes = { }
  end

  def add_node(node_name)
    @nodes[node_name] ||= Node.new(node_name)
  end

  def add_edge(predecessor_name, successor_name)
    predecessor = @nodes[predecessor_name] || add_node(predecessor_name)
    successor = @nodes[successor_name] || add_node(successor_name)
    predecessor.add_edge(successor)
  end

  def [](name)
    @nodes[name]
  end

  def to_h
    @nodes.values.map(&:to_h).flatten(1)
  end

  def to_json
    to_h.to_json
  end
end
