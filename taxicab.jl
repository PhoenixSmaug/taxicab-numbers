using DataStructures
using Serialization
using Primes

"""
Compute General Taxicab Numbers
- Equation a^k + b^k = c^k + d^k with integers 1 <= a, b, c, d <= N, a != c and a >= b
- Background information: https://en.wikipedia.org/wiki/Taxicab_number
- Previous search limits: https://www.ams.org/journals/mcom/1998-67-223/S0025-5718-98-00979-X/S0025-5718-98-00979-X.pdf
- Quadratic space improvement via heap structure: https://www.ams.org/journals/mcom/2001-70-233/S0025-5718-00-01219-9/S0025-5718-00-01219-9.pdf
    - Instead of storing the O(N^2) possible values of a^k + b^k in a table and then finding duplicates, we use a min heap to loop trough all
      combinations (a, b) such that a^k + b^k is monotonously growing. If we encounter the same value y in a row, we have found two different
      sum representations and y is a taxicab number of power k.

(c) Mia Muessig
"""

N = 10^7  # upper search limit, i.e. a, b <= N
k = 4  # power of the equation (k = 3:  https://oeis.org/A001235, k = 4: https://oeis.org/A018786, k = 5, 6 conjectured impossible)

function taxicab(k::Int64, N::Int64, h::BinaryMinHeap{Tuple{UInt128, UInt128, UInt128}} = BinaryMinHeap{Tuple{UInt128, UInt128, UInt128}}(), old::Vector{UInt128} = Vector{UInt128}([0, 0, 0]), count::Int64 = 0; prime = false)
    if isempty(h)  # h is not already set, start from the beginning
        # start with the diagonal entries (compare to Sec. 3 Refinements in https://www.ams.org/journals/mcom/2001-70-233/S0025-5718-00-01219-9/S0025-5718-00-01219-9.pdf)
        for i in 1 : N
            a = convert(UInt128, i)
            push!(h, (2 * a^k, a, a))
        end
    end

    steps = 0
    while !isempty(h)  # loop trough all combinations of a and b (a >= b) in ascending order
        (y, a, b) = pop!(h)  # remove minimal element

        if y == old[1]  # a^k + b^k is the same as oldA^k + oldB^k and so (a, b, c = oldA, d = oldB) is a solution to the diophantine equation
            if !prime || (isprime(a) && isprime(b) && isprime(old[2]) && isprime(old[3]))
                count += 1
                println(string(count) * " " * string(y) * " (" * string(a) * "^" * string(k) * " + " * string(b) * "^" * string(k) * " = " * string(old[2]) * "^" * string(k) * " + " * string(old[3]) * "^" * string(k) * ")")
            end
        end
        
        old[1] = y; old[2] = a; old[3] = b

        if a < N  # if upper limit is not reached, put next element in heap
            push!(h, ((a+1)^k + b^k, a+1, b))
        end

        steps += 1
        if steps % 10^9 == 0
            println(BigInt.(old))
            serialize("save.dat", (h, old, count))  # save to file
        end
    end
end

taxicab(k, N; prime = true)  # restart from the beginning
#h, old, count = deserialize("save.dat")  # start from last savepoint
#taxicab(k, N, h, old, count)