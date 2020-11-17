require 'strscan'
require_relative '../lib/scan_file.rb'
require_relative '../lib/errors_file.rb'
require_relative '../lib/colors_file.rb'

@lines_to_use = []

def add_error
  @total_errors = @error_arr.length + @punctation_arr.length
end

def no_errors
  return puts 'No errors detected'.green unless @total_errors != 0

  case @total_errors
  when 1
    puts "Total error #{@total_errors}".red
  else
    puts "Total errors #{@total_errors}".red
  end
end

def show_punctuation
  text = "\nChecking for {}, [] and ()".light_blue
  puts text.blue unless @error_arr.empty? || @punctation_arr.empty?
  @punctation_arr.map { |hash| hash[:sign] }.each_with_index do |value, index|
    temp = @punctation_arr[index][:result].abs
    puts "Missing #{temp} #{value} #{@punctation_arr[index][:msg]}"
  end
end

def error_lines
  @lines_to_use = @error_arr.map { |hash| hash[:lpos] }.uniq.sort!
end

def show_errors
  return unless @total_errors.positive?

  @lines_to_use.each_with_index do |value, _index|
    @error_arr.each_with_index do |_x, y|
      txt1 = "\nLine #{value} col #{@error_arr[y][:offset]}:".blue
      txt2 = " #{@error_arr[y][:msg]}".red
      txt = txt1 + txt2
      puts txt if @error_arr[y][:lpos] == value
    end
  end
end

check_error('test.rb')
add_error
no_errors
error_lines
show_errors
show_punctuation
