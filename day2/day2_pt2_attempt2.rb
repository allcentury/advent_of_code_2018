require 'pry'
require 'trie'
require 'set'
input = File.read("input.txt").split("\n")


window_size = input.first.length

def find_match(input, offset)
  results = Set.new
  offset.times do |i|
    # Build new Trie with offset word
    trie = Trie.new
    input.each do |word|
      offset_word = word[i..-1] + word[0...i]
      trie.add offset_word
    end

    input.each do |word|
      sub_word = word[i..-1] + word[0...i - 1]
      offset_word = word[i..-1] + word[0...i]
      children = trie.children(sub_word)
      children.reject! { |c| c == offset_word }
      if !children.empty?
        chars = word.chars
        chars.delete_at(i - 1)
        results << chars.join
      end
    end
  end
  results
end

# input = [
#   "uwkfmdjxyxlbgnrotcfpvswaqh",
#   "uwzfmdjxyxlbgnrotcfpvswaqh"
# ]
# window_size = 4
p find_match(input, window_size)


