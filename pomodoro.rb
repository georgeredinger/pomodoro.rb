#! /usr/bin/ruby

require 'ostruct'

notifier = 'growlnotify -s -m '
pomodoro = OpenStruct.new(:name => 'Pomodoro', :time => 25 * 60, :message => 'Pomodoro Time is up!', :notifier => notifier)
short_break = OpenStruct.new(:name => 'Short break', :time => 5 * 60, :message => 'Pomodoro Break is up!', :notifier => notifier)
long_break = OpenStruct.new(:name => 'Long break', :time => 15 * 60, :message => 'Pomodoro Break is up!', :notifier => notifier)

def say_start
  puts "started: #{Time.now.strftime('%H:%M')}"
end

def progress(time, number_of_chunks)
  chunk = 1.0 * time / number_of_chunks
  1.upto(number_of_chunks) do |i|
    print "|"
    print '==' * i
    print '  ' * (number_of_chunks - i)
    print "|\r"
    STDOUT.flush
    sleep chunk
  end
end

def start(chunk)
  puts "\n#{chunk.name}!"
  say_start
  progress(chunk.time, 20)
  `#{chunk.notifier} #{chunk.message}`
end

pomodoro_count = 0
loop do
  pomodoro_count += 1
  start(pomodoro)
  pomodoro_count % 4 == 0 ? start(long_break) : start(short_break)
end
