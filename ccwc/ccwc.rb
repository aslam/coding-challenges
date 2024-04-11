#!/usr/bin/env ruby

require 'optparse'

@options = {
  bytes: false,
  chars: false,
  words: false,
  lines: false
}

OptionParser.new do |opts|
  opts.on("-c", "--bytes", "Count bytes") do
    @options[:bytes] = true
  end

  opts.on("-l",  "--lines", "Count lines") do
    @options[:lines] = true
  end

  opts.on("-w", "--words", "Count words") do
    @options[:words] = true
  end

  opts.on("-m", "--chars", "Count characters") do
    @options[:chars] = true
  end
end.parse!

def options_given?
  @options.any? { |k,v| v == true }
end

if ARGV.empty?
  file = ARGF.read
else
  filename = ARGV.first
  file = File.read(filename)
end

class Filestats
  attr_accessor :file
  def initialize(input)
    @file = input
  end

  def bytes
    file.bytes.size
  end

  def lines
    file.lines.size
  end

  def words
    file.split(' ').size
  end

  def chars
    file.chars.count
  end
end

stats = Filestats.new(file)
result = []
final_options = options_given? ? @options.select { |k,v| v }.keys : [:lines, :words, :bytes]
final_options.each do |option|
  result << stats.send(option)
end

puts format("%s %s", result.join(' '), filename)
