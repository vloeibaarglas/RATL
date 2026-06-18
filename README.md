# RATL

A programming language based on R and suitable for code golf.

RATL (R-based Array Manipulation Language) is an esoteric, stack-based language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax.

The compiler works in R 3.0.0 or newer.

**Installation**: Unpack the files to a folder. Ensure R is installed on your system.

**Test**: `10.D&p` should produce a decimal multiplication table.

**Specification**: [RATL_SPEC.pdf](RATL_SPEC.pdf) — full symbol reference with R code mappings.

**Usage**: See the specification documented in the examples and definition files.

## Examples

### Addition
```
1 2+
```
`1` push 1, `2` push 2, `+` add → `3`

### Multiplication Table
```
10.D&p
```
`10.` range 1:10, `D` duplicate, `&` outer product, `p` print → 10×10 table

Note: `p` is optional when there's one value left on the stack — RATL prints it automatically.

### Statistical Mean
```
2 5:m
```
`2` push 2, `5:` range 2:5, `m` mean → `3.5`

Note: `.` is shorthand for `1:N` (1 arg), while `:` takes two args `N:M`.

### Primes
```
100.{mp}e
```
`100.` range 1:100, `{mp}` block: is prime?, `e` filter → primes ≤ 100

### Factorial
```
5fp
```
`5` push 5, `fp` factorial → `120`

### FizzBuzz
```
20.(
  D15%0=?'FizzBuzz'p]
  D15%0=~?
    D3%0=?'Fizz'p]
    D5%0=?'Buzz'p]
    D3%0=~?D5%0=~?Dp]]]
  x)
```
Loops 1:20, prints Fizz/Buzz/FizzBuzz per divisibility rules.

### Fibonacci
```
0 1
10.(
  x
  D p D L + M w
)
x x
```
First 10 Fibonacci numbers — uses clipboards L/M to hold previous two values.

### Collatz Sequence
```
6D Dp
"D1=?X]
  D2%0=?D2/;D3*1+]
  wxDDp
"x
```
Hailstone sequence starting at 6: 6→3→10→5→16→8→4→2→1

### Identity Matrix
```
3y!
```
3×3 identity matrix

### Sum of Squares
```
10.2^s
```
`10.` range 1:10, `2^` square each, `s` sum → `385`

## Architecture

1.  **Parser (`src/ratl_parse.R`)**: Tokenizes input into literals and blocks.
2.  **Evaluator (`src/ratl_eval.R`)**: Tree-walking interpreter that executes tokens on a live stack.
3.  **Dispatch (`src/ratl_dispatch.R`)**: Hashed environment for O(1) symbol lookup.
4.  **Stack (`src/ratl_stack.R`)**: Pointer-based stack implementation for performance.
5.  **Library (`src/ratl_lib.R`)**: Statistical and helper functions.

## Testing

```bash
make test
```

## License
MIT
