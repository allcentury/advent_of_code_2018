require 'pry'
require 'set'
require 'pp'

input = File.read("input.txt").strip

matches = ->(arr) do
  arr.each.with_index do |_el, i|
    a, b = arr[i], arr[i + 1]
    next unless a && b
    if a.swapcase == b
      arr[i] = nil
      arr[i + 1] = nil
    end
  end
end

squash = ->(chars) do
  previous_chars = nil
  while chars != previous_chars
    previous_chars = chars
    chars = matches.call(chars).compact
  end
  return chars
end


# input = "dabAcCaCBAcCcaDA"
# pt1_answer = squash.call(input.chars).join

# if pt1_answer == "dabCBAcaDA"
#   puts 'right answer'
# else
#   puts "wrong answer, expect: dabCBAcaDA but got: #{pt1_answer}"
# end


# pt 2

chars = input.chars
set = Set.new(chars.map(&:downcase))

puts "Set: #{set}"

pt2_answer = set.map do |letter|
  puts "working on letter: #{letter}"
  sub_string = chars.join.delete(letter).delete(letter.upcase)
  squash.call(sub_string.chars).size
end.min

puts pt2_answer

# if pt2_answer == 4
#   puts 'right answer'
# else
#   puts "wrong answer, expect: dabCBAcaDA but got: #{pt2_answer}"
# end
#



