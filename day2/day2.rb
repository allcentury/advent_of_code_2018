require 'pry'
input = File.read("input.txt").split("\n")

def includes?(str, size: 2)
  str.chars.each_with_object(Hash.new(0)) do |el, hash|
    hash[el] += 1
  end.values.any? { |v| v == size }
end


hash = Hash.new(0)
input.each do |str|
  if includes?(str)
    hash[2] += 1
  end
  if includes?(str, size: 3)
    hash[3] += 1
  end
end

puts hash[2] * hash[3]


binding.pry
