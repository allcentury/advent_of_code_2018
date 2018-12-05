require 'pry'
require 'date'
require 'pp'
input = File.read("input.txt").split("\n")

class Event
  attr_reader :timestamp, :action
  def initialize(timestamp, action)
    @timestamp = timestamp
    @action = action
  end

  def <=>(other)
    timestamp <=> other.timestamp
  end

  def new_guard?
    @action.include?("Guard")
  end

  def guard
    @action.match(/.*#(\d+)/)[1]
  end
end

class Guard
  attr_reader :id, :sleep_by_date, :events

  def initialize(id)
    @id = id
    @events = []
  end

  def add_event(event)
    @events << event
  end

  def total_sleep
    @sleep_by_date.inject(0) do |sum, (date, ranges)|
      ranges.each { |range| sum += (range.last - range.first) / 60 }
      sum
    end
  end

  def most_slept_minute
    @sleep_by_date.each_with_object({}) do |(date, ranges), hash|
      minutes_for_day = ranges.flat_map do |range|
        (range.first.min...range.last.min).to_a
      end
      hash[date] = minutes_for_day
    end.values.flatten.each_with_object(Hash.new(0)) do |minute, ctr|
      ctr[minute] += 1
    end.max_by { |min, amount| amount }
  end

  def calculate_sleep!
    @sleep_by_date = Hash.new { |h, k| h[k] = [] }
    @events.group_by { |e| e.timestamp.day }
      .each do |day, events|
        events.each_slice(2) do |events|
          timestamp = events.first.timestamp
          date = Date.new(timestamp.year, timestamp.month, timestamp.day)
          @sleep_by_date[date] << (events.first.timestamp...events.last.timestamp)
        end
      end
  end
end

# input = [
# "[1518-11-01 00:00] Guard #10 begins shift",
# "[1518-11-01 00:05] falls asleep",
# "[1518-11-01 00:25] wakes up",
# "[1518-11-01 00:30] falls asleep",
# "[1518-11-01 00:55] wakes up",
# "[1518-11-01 23:58] Guard #99 begins shift",
# "[1518-11-02 00:40] falls asleep",
# "[1518-11-02 00:50] wakes up",
# "[1518-11-03 00:05] Guard #10 begins shift",
# "[1518-11-03 00:24] falls asleep",
# "[1518-11-03 00:29] wakes up",
# "[1518-11-04 00:02] Guard #99 begins shift",
# "[1518-11-04 00:36] falls asleep",
# "[1518-11-04 00:46] wakes up",
# "[1518-11-05 00:03] Guard #99 begins shift",
# "[1518-11-05 00:45] falls asleep",
# "[1518-11-05 00:55] wakes up"
# ]

guards = input.map do |line|
  next unless line.include?("Guard")
  id = line.match(/\[(.*)\].*#(\d+) (\w+)/)[2]
  [id, Guard.new(id)]
end.compact.to_h


events = input.map do |line|
  timestamp, detail = line.match(/\[(.*)\](.*)/)[1..2]
  _, year, month, day, hours, minutes = timestamp.match(/(\d+)-(\d+)-(\d+) (\d+):(\d+)/).to_a
  time = Time.new(year, month, day, hours, minutes)
  Event.new(time, detail)
end


# add events to the right gaurds
@gaurd = nil
events.sort.each do |event|
  if event.new_guard?
    @gaurd = guards[event.guard]
  else
    @gaurd.add_event(event)
  end
end


# Now that all the events are with the right guards
# calculate how much they sleep
guards_with_total_sleep = guards.each { |_, guard| guard.calculate_sleep! }
  .map { |id, g| [id, g.total_sleep] }.to_h

guard = guards[guards_with_total_sleep.max_by { |k| k.last }.first]
puts "Guard with the most sleep: #{guard.id}"

puts "Answer: "
puts "ID: #{guard.id}"
puts "Total sleep: #{guard.total_sleep}"
puts "Slept the most: #{guard.most_slept_minute}"
puts "Answer: #{guard.id.to_i * guard.most_slept_minute.first}"

# pt 2

answer = guards.values.each_with_object({}) do |guard, hash|
  unless guard.events.empty?
    hash[guard.id] = guard.most_slept_minute
  end
end.max_by { |tuple| tuple[1][1] }

puts "Pt2 Answer: " + "#{answer.first.to_i * answer[1][0]}"
