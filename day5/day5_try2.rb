require 'pry'
require 'set'

input = File.read("input.txt").strip

stack = input.chars

def get_answer(stack, skip_letter: nil)
  stack.each_with_object([]) do |el, final_stack|
    next if skip_letter == el.downcase

    if final_stack.empty?
      final_stack << el
    else
      prev = final_stack.last

      if el.swapcase == prev
        final_stack.pop
      else
        final_stack << el
      end
    end
  end
end

# pt 1
puts get_answer(stack).size



# pt2
set = Set.new(stack).map(&:downcase)

sizes = set.map do |letter|
  get_answer(stack, skip_letter: letter).size
end

p sizes.min

# set.
