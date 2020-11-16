require_relative '../lib/errors_file.rb'

describe LintFile do
  let(:original) { 'test.rb' }
  let(:file_open) { LintFile.new(original) }

  describe 'File reader #initialize' do
    it 'Returns a file instance' do
      expect(file_open.file.class).to eql(File.open(original).class)
    end
    it "returns a unique instance of an open file as when using Ruby's File class" do
      expect(file_open.lines).not_to eql(File.open(original))
    end
  end

  describe 'Reading and storing lines from file #read' do
    it 'All data is an array' do
      expect(file_open.lines.class).to eql(Array)
    end
    it 'Lines equal to length of array' do
      file_open.read
      expect(file_open.lines.count).to eql(File.open(original).count)
    end
  end

  describe 'Indentation method #indentation' do
    it 'There is one Indentation error on line (lpos) 4 ' do
      check_error(original)
      expect(@error_arr.include?({ lpos: 4, msg: 'Indentation Error Detected', offset: 0 })).to eql(true)
    end
  end

  describe 'Whitespace trailing #trailing_whitespace' do
    it 'Second line (index = 1) has a whitespace at the end of the line' do
      check_error(original)
      expect(
        trailing_whitespace(1).include?({ lpos: 4, msg: 'Indentation Error Detected', offset: 0 })
      ).to eql(true)
    end

    it 'There is one Indentation error on line (lpos) 4 ' do
      check_error(original)
      expect(@error_arr.include?({ lpos: 4, msg: 'Indentation Error Detected', offset: 0 })).to eql(true)
    end
  end

  describe 'Check if all tags open are closed' do
    it 'If curly brace close is missing it returns the sign and the number of punctuation missing' do
      @tags = ['(', [')', '{']]
      @punctation_arr = []
      expect(tags_results).to eql([{ msg: 'to close', result: 1, sign: 'Curly {}' }])
    end

    it 'Same tags open as close' do
      @tags = ['(', [')', '{'], '}']
      @punctation_arr = []
      expect(@punctation_arr.count != 0).not_to eql(true)
    end
  end
end
