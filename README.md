# RATL

A programming language based on R and suitable for code golf.

RATL (R-based Array Manipulation Language) is an esoteric, stack-based language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax.

The compiler works in R 3.0.0 or newer.

**Installation**: Unpack the files to a folder. Ensure R is installed on your system.

**Test**: Running `./src/RATL.R "10.D&p"` from the shell should produce a decimal multiplication table.

**Specification**: [RATL_SPEC.pdf](RATL_SPEC.pdf) — full symbol reference with R code mappings.

**Usage**: See the specification documented in the examples and definition files.

## Examples

### Addition
```bash
./src/RATL.R "12+"
```
`1` push 1, `2` push 2, `+` add, `p` print → `3`

### Multiplication Table
```bash
./src/RATL.R "10.D&p"
```
`10.` range 1:10, `D` duplicate, `&` outer product, `p` print → 10×10 table

### Statistical Mean
```bash
./src/RATL.R "5.Sm"
```
`5.` range 1:5, `S` to numeric vector, `m` mean → `3`

### FizzBuzz
```bash
./src/RATL.R "$(cat examples/17_fizzbuzz.ratl)"
```
Loops 1:20, prints Fizz/Buzz/FizzBuzz per divisibility rules.

### Primes
```bash
./src/RATL.R "100.{mp}e"
```
`100.` range 1:100, `{mp}` block: is prime?, `e` filter → primes ≤ 100

### Factorial
```bash
./src/RATL.R "5fp"
```
`5` push 5, `fp` factorial → `120`

### Fibonacci
```bash
./src/RATL.R "10r1.Dp"
```
`10` push 10, `r1` 1:N, `.` range, `D` dup, `p` print — generates via loop

## Architecture

1.  **Parser (`src/ratl_parse.R`)**: Tokenizes input into literals and blocks.
2.  **Evaluator (`src/ratl_eval.R`)**: Tree-walking interpreter that executes tokens on a live stack.
3.  **Dispatch (`src/ratl_dispatch.R`)**: Hashed environment for O(1) symbol lookup.
4.  **Stack (`src/ratl_stack.R`)**: Pointer-based stack implementation for performance.
5.  **Library (`src/ratl_lib.R`)**: Statistical and helper functions.

## Testing

Run all tests and example checks:
```bash
make test
```

## License
MIT
