require 'strscan'
require_relative 'colors_file.rb'

# Read & scan every line of the file
class LintFile
  attr_reader :file, :lines
  def initialize(filepath)
    @file = File.open(filepath)
    @lines = []
  end

  def read
    @file.each_with_index do |line, ind|
      @lines[ind] = StringScanner.new(line)
    end
  end
end
