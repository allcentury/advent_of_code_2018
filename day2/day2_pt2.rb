require 'pry'
input = File.read("input.txt").split("\n")

length = input.first.length

def similar_to?(array, word)
  array.each do |word2|
    ctr = 0
    word2.chars.each.with_index do |el, j|
      if el == word[j]
        ctr += 1
      end
      if ctr == word.length - 1
        return word2
      end
    end
  end
  nil
end

similar = []
input.each.with_index do |word, i|

  similar_word = similar_to?(input[(i + 1)..-1], word)
  similar << [
    word,
    similar_word
  ] if similar_word
  # word.chars.each.with_index do |el, j|
  #   if similar_to?(input[(i + 1)..-1])
  #   end
  # end
end

puts similar

binding.pry

