require 'strscan'

s = StringScanner.new('This is an example string')
s.eos?               # -> false

p s
p s.scan(/\w+/)      # -> "This"
p s.scan(/\w+/)      # -> nil
p s.scan(/\s+/)      # -> " "
p s.scan(/\s+/)      # -> nil
p s.scan(/\w+/)      # -> "is"
s.eos?               # -> false

p s.scan(/\s+/)      # -> " "
p s.scan(/\w+/)      # -> "an"
p s.scan(/\s+/)      # -> " "
p s.scan(/\w+/)      # -> "example"
p s.scan(/\s+/)      # -> " "
p s.scan(/\w+/)      # -> "string"
s.eos?               # -> true

p s.scan(/\s+/)      # -> nil
p s.scan(/\w+/)      # -> nil
