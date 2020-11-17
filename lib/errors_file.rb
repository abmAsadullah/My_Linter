require 'strscan'
require_relative 'scan_file.rb'
require_relative 'colors_file.rb'

def check_error(filepath)
  @check_file = LintFile.new(filepath)
  @check_file.read
  @punctation_arr, @error_arr, @empty_line, @tags = Array.new(4) { [] }
  @double_empty_line = []
  @pos_white = 0

  empty_line
  double_empty_line

  check_loop
end

def check_loop
  @check_file.lines.length.times do |line|
    indentation(line)
    trailing_whitespace(line)
    whitespace(line)
    count_tags(line)
    position_whitespace(line)
  end
  tags_results
end

def whitespace(line)
  text = 'Excess Whitespace Detected'
  return if @empty_line.include?(line + 1)

  pos = @check_file.lines[line].string.gsub(/ {2,}/).map { |_, _arr| Regexp.last_match.begin(0) }
  pos.shift if pos[0].nil? || pos[0].zero?
  @error_arr.push(lpos: line + 1, msg: text, offset: pos) unless pos[0].nil?
end

def trailing_whitespace(line)
  text = 'Trailing Whitespace Detected'
  return if @empty_line.include?(line + 1)

  pointer = @check_file.lines[line].string.length
  return unless @check_file.lines[line].string.reverse[0..1].match?(/ {1,}/)

  @error_arr.push(lpos: line + 1, msg: text, offset: pointer)
end

def position_whitespace(line)
  pos = @check_file.lines[line].string
  pos.gsub(/^\s*/i).map { |_, _arr| Regexp.last_match.end(0) }
end

def indentation(line)
  return if @empty_line.include?(line + 1)

  text = 'Indentation Error Detected'
  pos = position_whitespace(line)
  test_end(line)
 
  if pos[0] != @pos_white
    @error_arr.push(lpos: line + 1, msg: text, offset: pos[0])
  end

  test_def(line)
end

def test_def(line)
  @pos_white = 2 if @check_file.lines[line].string =~ /\bdef\b/i
end

def test_end(line)
  @pos_white = 0 if @check_file.lines[line].string =~ /\bend\b/i
end

def empty_line
  @check_file.lines.length.times do |line|
    @empty_line << line + 1 if @check_file.lines[line].string.strip.empty?
  end
end

def double_empty_line
  text_msg = 'Double or more empty lines'
  @empty_line.each_with_index do |x, y|
    if x == @empty_line[y - 1] + 1
      @double_empty_line << @empty_line[y]
      @error_arr.push(lpos: @empty_line[y], msg: text_msg, offset: nil)
    end
  end
end

def count_tags(line)
  @tags << @check_file.lines[line].string.scan(/\p{Ps}/)
  @tags << @check_file.lines[line].string.scan(/\p{Pe}/)
end

def tags_results
  @tags.flatten!
  curly_o_count = @tags.count('{')
  parenthesis_o_count = @tags.count('(')
  brackets_o_count = @tags.count('[')

  curly_c_count = @tags.count('}')
  parenthesis_c_count = @tags.count(')')
  brackets_c_count = @tags.count(']')

  compare(brackets_o_count, brackets_c_count, 'Brackets []')
  compare(parenthesis_o_count, parenthesis_c_count, 'Parenthesis ()')
  compare(curly_o_count, curly_c_count, 'Curly {}')
end

def compare(open, close, punct)
  result = open - close
  case result
  when (-10_000..-1)
    @punctation_arr.push(sign: punct, result: result, msg: 'to open')
  when (1..10_000)
    @punctation_arr.push(sign: punct, result: result, msg: 'to close')
  end
end
