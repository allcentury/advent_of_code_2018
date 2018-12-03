require 'pry'
require 'pp'
input = File.read("input.txt").split("\n")

class Rectangle
  def self.build(row)
    id, _, position, dimensions = row.split
    pos_vals = position.match(/(\d+),(\d+)/).to_a[1..-1].map(&:to_i)
    dim_vals = dimensions.match(/(\d+)x(\d+)/).to_a[1..-1].map(&:to_i)
    new(
      left_pad: pos_vals.first,
      top_pad: pos_vals.last,
      width: dim_vals.first,
      height: dim_vals.last,
      id: id,
    )
  end

  attr_reader :left_pad, :top_pad
  attr_reader :width, :height
  attr_reader :id
  def initialize(left_pad:, top_pad:, width:, height:, id:)
    @left_pad = left_pad
    @top_pad = top_pad
    @width = width
    @height = height
    @id = id
  end

  def top_left_corner
    [
      top_pad,
      left_pad,
    ]
  end

  def bottom_right_corner
    [
      top_pad + height - 1,
      left_pad + width - 1,
    ]
  end

  def top_right_corner
    [
      top_pad,
      left_pad + width - 1,
    ]
  end

  def bottom_left_corner
    [
      top_pad + height - 1,
      left_pad
    ]
  end

  def corners
    [
      top_left_corner,
      top_right_corner,
      bottom_right_corner,
      bottom_left_corner,
    ]
  end

  # [[259, 328], [260, 328], [2

  #  left_pad = 3
  #  top_pad = 2
  #  width = 5
  #  height = 4
  #  5x4
  #
  #  [2, 4]
  #  [2, 5]
  #  [2, 6]
  #  [2, 7]
  #  [2. 8]
  #  [3, 4]
  # ...........
  # ...........
  # ...#####...
  # ...#####...
  # ...#####...
  # ...#####...
  # ...........
  # ...........
  # ...........
  #
  def cells
    positions = []
    width.times do |i| # 0 -> 5
      height.times do |j| # 0 -> 4
        positions << [
          top_pad + j,
          left_pad + i,
        ]
      end
    end
    positions
  end

end

def insert_into_matrix(matrix, rectangle)
  rectangle.cells.each do |cell|
    found_cell = matrix[cell.first][cell.last]
    new_val = if found_cell == "."
      rectangle.id
    else
      "X"
    end
    matrix[cell.first][cell.last] = new_val
  end
end

matrix = Array.new(1000) { Array.new(1000, ".") }

# smaller input
# input = [
#   "#1 @ 1,3: 4x4",
#   "#2 @ 3,1: 4x4",
#   "#3 @ 5,5: 2x2",
# ]
#
# matrix = Array.new(8) { Array.new(8, ".") }


rectangles = input.map { |row| Rectangle.build(row) }

rectangles.each do |rectangle|
  insert_into_matrix(matrix, rectangle)
end

ctr = 0
matrix.each do |row|
  row.each do |cell|
    ctr += 1 if cell == "X"
  end
end
p ctr

# pt 2
#
rectangles.each do |rectangle|
  # binding.pry if rectangle.id == "#3"
  result = rectangle.cells.all? do |cell|
    matrix[cell.first][cell.last] == rectangle.id
  end

  if result
    puts "ID: #{rectangle.id}"
  end
end



