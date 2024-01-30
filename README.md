# Solver for the general Taxicab equation

The general Taxicab equation is:
```math
a^k + b^k = c^k + d^k \quad a, b, c, d \in \mathbb{N}
```

To eliminate duplicates and trivial solutions, the additional constraints $a \neq c, a \geq b, c \geq d$ are usually added. The history of this problem is nicely summarized on [Wikipedia](https://en.wikipedia.org/wiki/Taxicab_number). For $k = 3$ the sequence is known as [A001235](https://oeis.org/A001235), for $k = 4$ as [A018786](https://oeis.org/A018786) and $k = 5$ is conjectured to be impossible. For the latter Randy L. Ekl [showed computaionally](https://www.ams.org/journals/mcom/1998-67-223/S0025-5718-98-00979-X/S0025-5718-98-00979-X.pdf) that no solution $a^5 + b^5 = c^5 + d^5 \leq 4.01 \cdot 10^{30}$ exists. Using this solver I was able to extend this result and demonstrate that no solution exists $\leq 10^{34}$.

To solve this equation algorithmically, an upper bound $N$ with $a, b \leq N$ is chosen. One then constructs a table with value $a^k + b^k$ for all combinations $(a, b)$ with $a \geq b$ and then searches for duplicates. Each duplicate has at least two representations as the sum $a^k + b^k$ and is therefore a taxicab number. The memory complexity of this approach is $O(N^2)$ for the table, which means a memory requirement of hundreds of gigabytes already for $N = 10^6$.

In [Enumerating solutions to p(a) + q(b) = r(c) + s(d)](https://www.ams.org/journals/mcom/2001-70-233/S0025-5718-00-01219-9/S0025-5718-00-01219-9.pdf) Daniel J. Bernstein describes a solution to this problem. He proposes to replace the table with a minimal heap that is iteratively updated and therefore contains only $O(N)$ values at each time point. This also allows us to enumerate all combinations $(a, b)$ such that the result $a^k + b^k$ is in ascending order. In this way, we can easily find duplicate values as they succeed each other directly. Further details can be found in section 3 of the paper.

(c) Mia Müßig
