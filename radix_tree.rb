class Node
  def initialize(index=0, edges)
    #0 index root
    @index = index
    @edges = edges
  end

  def add_edge(edge)
    @edges << edge
  end

  def edges
    @edges
  end

  def to_s
    { @index => @edges }
  end

  def is_leaf?
    # not root and without edges
    @index != 0 && @edges.empty?
  end
end

class Edge
  def initialize(prefix, value, next_node_index)
    @prefix = prefix
    @value = value
    @next_node_indicies = [next_node_index]
  end

  def to_s
    # {"e"=>[0]}
    { @prefix => [@value] }
  end

  def label
    @prefix
  end

  def value
    @value
  end

  def add_next_node_index(index)
    @next_node_indicies << index
  end

  def target_nodes
    @next_node_indicies
  end
end


class RadixTree
  def initialize(tree)
    @tree = tree
  end

  def has?(word)
    next_edge, traverse_node, elements_found = search(word)

    traverse_node != nil && traverse_node.is_leaf? && elements_found == word.length
  end

  def value_for(word)
    next_edge, traverse_node, elements_found = search(word)

    next_edge.value if traverse_node != nil && traverse_node.is_leaf? && elements_found == word.length
  end

  def [](word)
    next_edge, traverse_node, elements_found = search(word)

    if traverse_node != nil && traverse_node.is_leaf? && elements_found == word.length
      { word => next_edge.value }
    end
  end

  def search(word)
    traverse_node = @tree[0]
    elements_found = 0

    while traverse_node != nil && !traverse_node.is_leaf? && elements_found < word.length do

      next_edge = traverse_node.edges.select{ |edge| suffix(word, elements_found).start_with?(edge.label) }.first

      if next_edge != nil
        next_edge.target_nodes.each do |target_node|
          traverse_node = @tree[target_node.first]
          elements_found += next_edge.label.length
        end
      else
        traverse_node = nil
      end
    end

    [next_edge, traverse_node, elements_found]
  end

  def to_h
    # recursive build map of tree
  end

  private

  def suffix(word, elements_found)
    n = word.length - elements_found
    word.last(n)
  end
end


           -> edge(rub, root)
                                             -> edge(us, [2]) -> node(2)
node(root) -> edge(roman, [1]) -> node(1)
                                             -> edge(e, [2]) -> node(2)



node(root) -> edge(t, [next_node_index, next_node_index]) ->

node_index = 0
root = Node.new([])

node_index += 1

first_edge = Edge.new('roman', '0', [node_index])
root.add_edge(first_edge)

first_node = Node.new(node_index, [])
node_index += 1

second_edge = Edge.new('us', '1', [node_index])
second_node = Node.new(node_index, [])
node_index += 1

third_edge = Edge.new('e', '2', [node_index])
third_node = Node.new(node_index, [])
node_index += 1

first_node.add_edge(second_edge)
first_node.add_edge(third_edge)

tree = [root, first_node, second_node, third_node]

class String
  def last(limit = 1)
    if limit == 0
      ''
    elsif limit >= size
      self.dup
    else
      from(-limit)
    end
  end

  def from(position)
    self[position..-1]
  end
end
