require 'pp'
require 'pry'

class Node
  attr_reader :coords, :name
  attr_accessor :dirty
  attr_accessor :children

  def initialize(coords, name)
    @coords = coords
    @name = name
    @dirty = false
    @children = []
  end

  def to_s
    @name
  end

  def neighbors
    row, col = coords

    left = [
      row,
      col - 1,
    ]

    right = [
      row,
      col + 1,
    ]

    up = [
      row - 1,
      col,
    ]

    down = [
      row + 1,
      col
    ]

    [
      left,
      right,
      up,
      down
    ]
  end

  def ==(other)
    @name == other
  end

  def inspect
    "\"#{@name}\""
  end
end

characters = ("A".."AZ").to_a.reverse

# input = [
#   [1, 1],
#   [1, 6],
#   [8, 3],
#   [3, 4],
#   [5, 5],
#   [8, 9],
# ]


input = File.read("input.txt").split("\n").map  { |row| row.split(",").map(&:strip).map(&:to_i) }

nodes = input.map do |pair|
  char = characters.pop
  fail unless char
  Node.new(pair, char)
end

DOT = ".".freeze

grid = Array.new(input.map(&:first).max + 2) { Array.new(input.map(&:last).max + 1, DOT) }

# build grid
nodes.each do |node|
  grid[node.coords.last][node.coords.first] = node
end

# apply per cell
grid.each.with_index do |row, i|
  row.each.with_index do |col, j|
    if col == DOT
      # get the closest node
      distances = nodes.map { |node| [node, (j - node.coords.first).abs + (i - node.coords.last).abs] }
      map = distances.group_by { |a| a[1] }
      smallest = map.min_by { |k, v| k }
      smallest_coord = smallest[0]
      smallest_node = smallest[1][0][0]

      # make sure there is only one node who wants this cell
      if map[smallest_coord].size == 1
        child = Node.new([i, j], smallest_node)

        # find and mark any children with infinite edges
        child.neighbors.each do |neighbor|
          if grid.dig(neighbor.first, neighbor.last).nil? || neighbor.any? { |n| n < 0 }
            child.dirty = true
          end
        end

        smallest_node.children << child
        grid[i][j] = child
      end
    else
    end
  end
end

pt1_answer = nodes.select { |n| n.children.all? { |c| c.dirty == false } }.max_by { |n| n.children.count }.children.count + 1

puts pt1_answer

# pt 2

pt2_answer = []
grid.each.with_index do |row, i|
  row.each.with_index do |cell, j|
    distances = nodes.map do |node|
      [node, (j - node.coords.first).abs + (i - node.coords.last).abs]
    end.to_h

    val = distances.values.sum
    pt2_answer << val if val < 10000
  end
end

p pt_answer = pt2_answer.size

# ..........
# .A........
# ..........
# ........C.
# ...D......
# .....E....
# .B........
# ..........
# ..........
# ........F.
#
sample_grid = [
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, "A", DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, "C", DOT],
  [DOT, DOT, DOT, "D", DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, "E", DOT, DOT, DOT, DOT],
  [DOT, "B", DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT],
  [DOT, DOT, DOT, DOT, DOT, DOT, DOT, DOT, "F", DOT],
]

# sample_grid_2 = [
#   aaaaa.cccc
#   aAaaa.cccc
#   aaaddecccc
#   aadddeccCc
#     ..dDdeeccc
#   bb.deEeecc
#   bBb.eeee..
#     bbb.eeefff
#   bbb.eeffff
#   bbb.ffffFf
# ]

# if grid == sample_grid
#   puts "correct"
# else
#   puts "wrong"
#   puts "my grid:"
#   pp grid
#   grid.each do |row|
#     puts row.join
#   end
#   puts
#   puts "ideal grid"
#   puts
#   # pp sample_grid
#   puts <<~EOF
#   aaaaa.cccc
#   aAaaa.cccc
#   aaaddecccc
#   aadddeccCc
#   ..dDdeeccc
#   bb.deEeecc
#   bBb.eeee..
#   bbb.eeefff
#   bbb.eeffff
#   bbb.ffffFf
#   EOF
# end
#
