class Node
  def initialize(index=0, edges)
    #0 index root
    @index = index
    @edges = edges
  end

  #debug
  def edges=(edges)
    @edges = edges
  end

  def index
    @index
  end

  def add_edge(edge)
    edge.set_current_node(@index)
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
    @next_node_index = next_node_index
    @current_node_index = nil
  end

  def label
    @prefix
  end

  def set_label(string)
    @prefix = string
  end

  def value
    @value
  end

  def set_value(value)
    @value = value
  end

  def set_next_node_index(index)
    @next_node_indicies = index
  end

  def target_node
    @next_node_index
  end

  def current_node
    @current_node_index
  end

  def set_current_node(index)
    @current_node_index = index
  end
end


class RadixTree
  def initialize(array_of_words_with_values)
    @root = Node.new([])
    @tree = [@root]
    @index_counter = 0

    fill_tree(array_of_words_with_values)
  end

  def tree
    @tree
  end

  def add(word, value)
    edge_in_tree, traverse_node = search_2(word)

    if edge_in_tree
      edge_value = edge_in_tree&.value
      edge_label =  edge_in_tree&.label

      common_prefix = intersection(edge_label, word)

      common_prefix_node = @tree[edge_in_tree.current_node]

      new_node_index = edge_in_tree.target_node + 1


      first_edge_label = edge_label.sub(common_prefix, '')

      unless first_edge_label.empty?
        first_edge_value = edge_value
        first_edge = Edge.new(first_edge_label, first_edge_value, new_node_index)

        first_edge_node = Node.new(new_node_index, [])
        @tree << first_edge_node

        new_node_index += 1
      end

      second_edge_label = word.sub(common_prefix, '')
      second_edge_value = value
      second_edge = Edge.new(second_edge_label, second_edge_value, new_node_index)

      second_edge_node = Node.new(new_node_index, [])
      @tree << second_edge_node

      edge_in_tree.set_label(common_prefix)
      edge_in_tree.set_value(nil) unless first_edge_label.empty?

      @tree[edge_in_tree.target_node].add_edge(first_edge) unless first_edge_label.empty?
      @tree[edge_in_tree.target_node].add_edge(second_edge)
    else
      new_node_index = @index_counter += 1

      edge = Edge.new(word, value, new_node_index)
      node = Node.new(new_node_index, [])

      @root.add_edge(edge)
      @tree << node
    end
  end


  def has?(word)
    next_edge, traverse_node, elements_found = search(word)

    traverse_node != nil && traverse_node.is_leaf? && elements_found == word.length || !next_edge.value.empty? && !next_edge.label.empty?
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
        traverse_node = @tree[next_edge.target_node]
        elements_found += next_edge.label.length
      else
        traverse_node = nil
      end
    end

    [next_edge, traverse_node, elements_found]
  end

  def search_2(word)
    traverse_node = @tree[0]

    while traverse_node != nil && !traverse_node.is_leaf? do

      next_edge = traverse_node.edges.select{ |edge| !intersection(word, edge.label).empty? }.first

      if next_edge != nil
        traverse_node = @tree[next_edge.target_node]
      else
        traverse_node = nil
      end
    end

    [next_edge, traverse_node]
  end

  def to_h
    # recursive build map of tree
  end

  private

  def intersection(str1, str2)
    match = []

    i = str1.length

    until i < 0 do
      charcter = str1[i]
      match << charcter if charcter == str2[i]

      i -= 1
    end
    return match.join.reverse
  end

  def suffix(word, elements_found)
    n = word.length - elements_found
    word.last(n)
  end

  def fill_tree(array_of_words_with_values)
    array_of_words_with_values.each do |hash|
      hash.each do |k,v|
        add(k, v)
      end
    end
  end
end

#
#            -> edge(rub, root)
#                                              -> edge(us, [2], '1') -> node(2)
# node(root) -> edge(roman, [1], nil) -> node(1)
#                                              -> edge(e, [2], '2') -> node(2)
#
#
#
# node(root, 0) -> edge(romanus,[1]) -> node(1) -> edge
#
# node_index = 0
# root = Node.new([])
#
# node_index += 1
#
# first_edge = Edge.new('roman', nil, node_index)
# root.add_edge(first_edge)
#
# first_node = Node.new(node_index, [])
# node_index = first_edge.target_node + 1
#
# second_edge = Edge.new('us', '1', node_index)
# second_node = Node.new(node_index, [])
# node_index = second_edge.target_node + 1
#
# third_edge = Edge.new('e', '2', node_index)
# third_node = Node.new(node_index, [])
# node_index = third_edge.target_node + 1
#
# first_node.add_edge(second_edge)
# first_node.add_edge(third_edge)
#
# tree = [root, first_node, second_node, third_node]

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
