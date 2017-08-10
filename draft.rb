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
