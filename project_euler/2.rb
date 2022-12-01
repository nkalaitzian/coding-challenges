terms = [1, 2]
fib_sequence = 3
sum = 2
while fib_sequence < 4_000_000 do
    puts "terms: #{terms.inspect}, Fib: #{fib_sequence}"
    fib_sequence = terms.sum
    sum += fib_sequence if fib_sequence % 2 == 0
    terms = [terms.pop, fib_sequence]
end
puts sum