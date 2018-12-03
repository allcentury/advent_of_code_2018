require 'pry'
require 'set'
input = File.read("input.txt").split("\n").map(&:to_i)

frequencies = Set.new
current = 0
frequencies << current
loops = 0
while true
  loops += 1
  # puts "On loop: #{loops}" if loops % 1000 == 0
  do_break = false

  input.each do |input|
    current += input
    if frequencies.include?(current)
      do_break = true
      break current
    else
      # puts "adding #{current} to #{frequencies}"
      frequencies << current
    end
  end
  break if do_break
end

puts current
