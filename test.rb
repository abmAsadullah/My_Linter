# rubocop:disable all
def something(str,  a, b) 
  x = a + b
x += 1
  puts "#{str} #{x}"
end

def just_print(str)
   puts   str 
end

def print_hash(arr_num, hash)
  puts "hash #{hash} & arr #{arr_num}"
end


a = 9 
b = 2
text = "Adding #{a} + #{b} + 1 equals to"

hash = {:key=>"first", :value=>1}

 arr = ['This is just
an example of
multiple  lines']

arr_num = [1, 2, 3, 4]

something(text, a, b)
just_print(arr)
print_hash(arr_num, hash)

# rubocop:enable all